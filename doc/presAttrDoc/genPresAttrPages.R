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
requireTable(PAV.DT)

PAV.DT[type=='LITERAL',val:=paste0("\\emph{'",val,"'}")]

PAV2.DT<-PAV.DT[,list(val=list(val),val.def=list(val.def)), by='attr']


PA.DT<-merge(PA.DT,PAV2.DT, by='attr')

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

    Animatable  <-PA.DT[attr==  attribute & variable=="Animatable"]$value 
    Initial     <-PA.DT[attr==  attribute & variable=="Initial"]$value
    Inherited   <-PA.DT[attr==  attribute & variable=="Inherited"]$value
    #values      <-PA.DT[attr==  attribute & variable=="Value"]$value
    values      <-unlist(PAV2.DT[attr==  attribute,val ])
    val.def     <-unlist(PAV2.DT[attr==  attribute, val.def])
  
    val.def[val.def==""]<-'todo'
    val.def<-stars2rds(val.def)
    val.def<-dollars2Eqns(val.def)
    
    # val.def<-gsub("\\*\\*([^\\$]+)\\*\\*", "\\\\strong\\{\\1\\}", val.def, perl=TRUE)
    # val.def<-gsub("\\*([^\\$]+)\\*", "\\\\emph\\{\\1\\}", val.def, perl=TRUE)
    
    #handle the description part
    description  <-PAD.DT[attr==attribute]$descript
    
    if(length(description)==0 || nchar(description)==0){
      print(paste(attribute, "Missing description"))
      description<-"Todo"
    }
    description<-validateString(description,"PresAttrPg description")
    
    
    
    # valDes<-"**ToDo!!!** "
    #title<-gsub("[-:]", ".", attribute) 
    presAttrLoc<-getPresAttrsLoc(attribute)
    # AppliesTo.elements<-paste("\\code{\\link{", AppliesTo.elements, "}}", sep="", collapse=", ")
    alink<-getPresAttrsLoc(attribute)
    txt<-c(
      rd.name(presAttrLoc),
      rd.title(asDot(attribute)),
      rd.description(description),
      rd.section("Available Attribute Values"),
      if(length(values)>0){
        c(rd.section("Available Attribute Values"),     
          rd.describe( rd.item(values,val.def) ) )
      } else {
        cat("WARNING",alink, ": missing attribute values\n")
        NULL
      },
      loc2animDescription(alink),
      #rd.itemize( rd.item(values, val.def)),
      rd.section("Used by the Elements"),
      rd.describe( elementsListing ),
      rd.keywords("internal")
    )
    tmp<-paste0(rd.close(txt) , collapse="\n" )
    tmp 
  }
  
  #attrs<-unique(PA.DT[variable=="Applies to"]$attr)
  attrs<-att2Elements.DT[,attr] 
  # attrs is presentaion attributes not list as regular
  # That is, we omit "font", "stroke-width", "marker-start", "marker-mid",   "marker-end",  "marker" 
  attrDefsPages.List<-lapply( attrs, addAttributeEntry)  
  rtv<-paste(attrDefsPages.List, collapse="\n")
  rtv 
}

genPresAttrPages()
