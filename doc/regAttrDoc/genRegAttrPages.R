if(!exists("rd.name")){
  library(data.table)
  source("tableLoader.R")
  source("./doc/helpers/commonDoc.R")
}
if(!exists("els2Cats")){
  source("./doc/helpers/els2Cats.R")
}
if(!exists("validateString")){
  source("./doc/helpers/validateString.R")
}


requireTable(AVD.DT, AVEL.DT, eaCS.DT, es.DT)
requireTable(RAD.DT) #link page attribute discription

link2loc<-function(z)sapply(strsplit(x = z,split = '#'), function(x){tail(unlist(x),1)})

RAD.DT[,loc := link2loc(link)]

cleanAttrValue<-function(vd){
  vd<-gsub('[-:]',".",vd)
  vd<-gsub('[‘’]',"*",vd)  
  vd<-gsub('[@]','',vd)
  vd<-gsub('…','...', vd)
  #valDes<-gsub("[@‘’ é…−™]","",valDes)
  vd<-gsub("[@‘’é…−™]","",vd)
  iconv(vd, "latin1", "ASCII", sub="")
  vd
}


# # To get element category
# eaCS.DT[name %like% "elements",]->el2CatLookup.DT
# names(el2CatLookup.DT)<-c("category","element")
# other<-setdiff(unique(es.DT$element), el2CatLookup.DT$element )
# el2CatLookup.DT<-rbind(
#   el2CatLookup.DT,
#   data.table(category="Unclassified", element=other)
# )

#Note some hanky panky with keytimes!!!, No more: removed from table.
AVD.DT[,value:=cleanAttrValue(value)]
AVD.DT[,value.def:=cleanAttrValue(value.def)]
AVD2.DT<-
  AVD.DT[,list(attr=unique(attr), 
               value=list(unique(value)), 
               value.def=list(unique(value.def))), by=loc]
AVD2.DT<-merge(AVD2.DT,RAD.DT,by = c("loc", "attr"), all=FALSE)

#AVEL.DT may have the link value repeated,
# only element will be unique.
AVEL2.DT<-
  AVEL.DT[, list(attr=unique(attr),
                 elements=list(unique(element)), 
                 loc=unique(loc)), by=link]

AVDEL.DT<-merge(AVEL2.DT,AVD2.DT, by=c("loc","attr"))


genRegAttrPages<-function(){
  
    
  
  addAttributeEntry<-function(alink){
    #showMe(alink)
   
    elements<-unlist(AVDEL.DT[loc==alink, elements])
    elementsListing<-els2Cats(elements)
    
    # elements.DT<-data.table(element=elements, loc=elements)
    # elements.DT<-merge(elements.DT,el2CatLookup.DT, by="element")
    # if(nrow(elements.DT)>0){
    #   elements.DT[,linkTo:=nameWithLink(element)]
    #   elements.DT<-elements.DT[,.(element,linkTo),by=category] #group by category
    #   elements.DT<-elements.DT[, 
    #                   rd.item(
    #                     rd.emph(category), paste0(linkTo ,collapse=", ")
    #                   ),
    #                   by=category 
    #                   ]
    #   elementsListing<-elements.DT$V1
    # } else {
    #   elementsListing<-"{No  Elements Applicable}{!}"
    # }
    
    title<-AVDEL.DT[loc==alink,attr]
    description<-AVDEL.DT[loc==alink,descript]
    values<-unlist(AVDEL.DT[loc==alink,value])
    valDes<-unlist(AVDEL.DT[loc==alink,value.def])
    
    description<-validateString(description,"regAttrPg description")
    if(is.null(description)){description<-"To do"}
    
    txt<-c(
      rd.name(alink),
      rd.title(asDot(title)),
      rd.description(description),
      if(length(values)>0){
        c(rd.section("Available Attribute Values"),     
          rd.describe( rd.item(values,valDes) ) )
      } else {
        cat("WARNING",alink, ": missing attribute values\n")
        NULL
      },   
      rd.section("Used by the Elements"), 
      rd.describe( elementsListing),
      rd.keywords("internal") 
    )
    tmp<-paste0( rd.close(txt) , collapse="\n" )
    tmp
  }
  
  links<-AVDEL.DT[,loc]
  attrDefsPages.List<-lapply( links, addAttributeEntry)
  
  rtv<-paste(attrDefsPages.List,  collapse="\n")
  rtv 
}
genRegAttrPages()->tmp
