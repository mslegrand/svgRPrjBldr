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


requireTable(AVD.DT, AVEL.DT, eaCS.DT, es.DT, PROLOG.DT, EPILOG.DT)
requireTable(ANIM.DT)
#requireTable(RAD.DT) #link page attribute discription
requireTable(RAF.DT) #link page attribute discription

#link2loc<-function(z)sapply(strsplit(x = z,split = '#'), function(x){tail(unlist(x),1)})

#RAD.DT[,loc := link2loc(link)]


cleanAttrValue<-function(vd){
  #vd<-gsub('[-:]',".",vd)
  vd<-gsub('[‘’]',"'",vd)  
  #vd<-gsub('[@]','',vd)
  vd<-gsub('…','...', vd)
  #vd<-gsub('[ \\d]%','\\%',vd)
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


AVD.DT[,value:=cleanAttrValue(value)]
AVD.DT[,value.def:=cleanAttrValue(value.def)]
#AVD.DT[type=='LITERAL',value:=paste0("\\emph{'",value,"'}")]

AVD.DT[,value.def:=stars2rds(value.def)]
AVD.DT[,value.def:=dollars2Eqns(value.def)]

EPILOG.DT[,value:=stars2rds(value)]
EPILOG.DT[,value:=dollars2Eqns(value)]
EPILOG.DT[,value:=gsub('é', 'e', value)]

AVD2.DT<- AVD.DT[, .(value=list(value), value.def=list(value.def)),  by=c("loc","attr") ]
  # AVD.DT[,list(attr=unique(attr), 
  #              value=list(unique(value)), 
  #              value.def=list(unique(value.def))), by=loc]
#AVD2.DT<-merge(AVD2.DT,RAD.DT,by = c("loc", "attr"), all=FALSE)

#AVEL.DT may have the link value repeated,
# only element will be unique.



AVEL2.DT<-AVEL.DT[, .(elements=list(element)), by=c("loc","attr") ]

AVEL2.DT<-merge(AVEL2.DT, RAF.DT[,.(attr,loc,choice,descript, prolog, epilog)], by=c("loc","attr"))
  # AVEL.DT[, list(attr=unique(attr),
  #                elements=list(unique(element)), 
  #                loc=unique(loc)), by=link]

AVDEL.DT<-merge(AVEL2.DT,AVD2.DT, by=c("loc","attr"))

# loc2animDescription<-function(alink){
#   tmp.DT<-ANIM.DT[loc==alink]
#   if(nrow(tmp.DT)!=1){
#     rtv<-NULL #maybe we should throw here?
#   } else if( tmp.DT$anim[1]==FALSE ){
#       print(alink)
#       rtv<-c(
#         rd.section("Animatable"),
#         "Not Animatable"
#       )
#   } else if  (is.na(tmp.DT$additive)) {
#     rtv<-NULL
#   } else {
#     ad<-tmp.DT$additive
#     yn<-ifelse(ad,"Yes","No")
#     a<-c(tmp.DT[1,animate],tmp.DT[1,set],tmp.DT[1,animateColor], tmp.DT[1,animateTransform])
#     aa<-c("animate","set","animateColor","animateTransform")[a==TRUE]
#     aa<-sapply(aa, nameWithLink) 
#     aa<-paste(aa,collapse=", ")
#     rtv<-c(
#       rd.section("Animatable"),
#       #rd.describe( aa ) ,
#       paste("Using: ", aa, "."),
#       paste("Supports Additive:", yn, ".")
#     )
#   }
#   rtv
# }

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
    if(length(description)>1){
      cat("alink=",alink, "\n")
      cat("length(description)=",length(description),"\n")
      stop()
    }
    description<-validateString(description,"regAttrPg description")
    if(is.null(description)){description<-"To do"}
    proKey<-AVDEL.DT[loc==alink,prolog]
    prologVal<-NULL
    if(!is.null(proKey)){
      prologVal<-PROLOG.DT[lookupKey==proKey,value]
    }
    
    epiKey<-AVDEL.DT[loc==alink,epilog]
    epilogVal<-NULL
    if(!is.null(epiKey) & nchar(epiKey)>0){
      epilogVal_u<-EPILOG.DT[lookupKey==epiKey,value]
      if(!is.null(epilogVal_u)){
        epilogVal<-str_split(epilogVal_u,"#' ")[[1]]
      }
    } 
    
    txt<-c(
      rd.name(alink),
      rd.title(asDot(title)),
      rd.description(description),
      if(length(values)>0){
        c(rd.section("Available Attribute Values"),
          prologVal,
          rd.describe( rd.item(values,valDes) ) )
      } else {
        cat("WARNING",alink, ": missing attribute values\n")
        NULL
      },  
      #if epilog then insert here
      epilogVal,
      loc2animDescription(alink),
      rd.section("Used by the Elements"), 
      rd.describe( elementsListing),
      rd.keywords("internal") 
    )
    # if(alink=="feBlendModeAttribute"){
    #   browser()
    # }
    tmp<-paste0( rd.close(txt) , collapse="\n" )
    tmp
  }
  #browser()
  links<-AVDEL.DT[,loc]
  attrDefsPages.List<-lapply( links, addAttributeEntry)
  
  rtv<-paste(attrDefsPages.List,  collapse="\n")
  rtv 
}
genRegAttrPages()->tmp
