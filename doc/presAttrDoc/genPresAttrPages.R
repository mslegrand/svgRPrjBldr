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


#PA.DT supplies Attributes, ElementsAppliedTo, Animatable, Initial, Inherited, Percentages
#PAD.DT for descriptions
requireTable(PAD.DT, PA.DT)

att2Elements.DT<-
  PA.DT[variable=="Applies to", list(elements=list(value)), by="attr"]


cat2el.DT<-rbind(
  data.table(category="text content element", element=c('altGlyph', 'textPath', 'text', 'tref', 'tspan')),
  data.table(category="image elements", element='image')
)
  

genPresAttrPages<-function(){
  
  addAttributeEntry<-function(attribute){ 
    #showMe(alink)
    expand.pres.Cat<-function(x){
      pec<-list(
        "text content element"= c('altGlyph', 'textPath', 'text', 'tref', 'tspan'),
        "image elements"=c('image')
      )
      match(x,names(pec),nomatch = 0L)->indx
      sort(c(unlist(pec[indx[indx>0]]), x[indx==0]))
    }
    
    
    elements<-unlist(att2Elements.DT[attr==attribute, elements])
    elements<- expand.pres.Cat( elements)
    #next split into categoryies
    elementsListing<-els2Cats(elements)
    # elements.DT<-data.table(element=elements, loc=elements)
    # 
    # elements.DT<-merge(elements.DT,el2CatLookup.DT, by="element")
    #  
    # if(nrow(elements.DT)>0){
    #   elements.DT[,linkTo:=nameWithLink(element)]
    #   elements.DT<-elements.DT[,.(element,linkTo),by=category] #group by category
    #   elements.DT<-elements.DT[, 
    #                            rd.item(
    #                              rd.emph(category), paste0(linkTo ,collapse=", ")
    #                            ),
    #                            by=category 
    #                            ]
    #   elementsListing<-elements.DT$V1
    # } else {
    #   elementsListing<-"{Not Currently Used}{!}"
    #   cat("Error in genPresAttrPages.R")
    # }
    # 
    
    Animatable  <-PA.DT[attr==  attribute & variable=="Animatable"]$value 
    Initial     <-PA.DT[attr==  attribute & variable=="Initial"]$value
    Inherited   <-PA.DT[attr==  attribute & variable=="Inherited"]$value
    values      <-PA.DT[attr==  attribute & variable=="Value"]$value
    Percentages <-PA.DT[attr==  attribute & variable=="Percentages"]$value
    
    #handle the description part
    description  <-PAD.DT[attr==attribute]$descript
    description<-validateString(description,"PresAttrPg description")
    if(is.null(description)){description<-"To do"}
    valDes<-"**ToDo!!!** "
    #title<-gsub("[-:]", ".", attribute) 
    presAttrLoc<-getPresAttrsLoc(attribute)
    # AppliesTo.elements<-paste("\\code{\\link{", AppliesTo.elements, "}}", sep="", collapse=", ")
    txt<-c(
      rd.name(presAttrLoc),
      rd.title(asDot(attribute)),
      rd.description(description),
      rd.section("Available Attribute Values"),     
      rd.itemize( rd.item(values, valDes)),
      rd.section("Used by the Elements"),
      rd.describe( elementsListing ),
      rd.keywords("internal")
    )
    tmp<-paste0(rd.close(txt) , collapse="\n" )
    tmp 
  }
  
  #attrs<-unique(PA.DT[variable=="Applies to"]$attr)
  attrs<-att2Elements.DT[,attr]
  attrDefsPages.List<-lapply( attrs, addAttributeEntry)  
  rtv<-paste(attrDefsPages.List, collapse="\n")
  rtv 
}
