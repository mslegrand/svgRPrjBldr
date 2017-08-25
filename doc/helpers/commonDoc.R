# common doc building operations
library(stringr)

requireTable(ANIM.DT)

stars2rds<-function(txt){
  txt<-gsub("\\*\\*([^\\*]+)\\*\\*", "\\\\strong\\{\\1\\}", txt, perl=TRUE)
  gsub("\\*([^\\*]+)\\*", "\\\\emph\\{\\1\\}", txt, perl=TRUE)
}

dollars2Eqns<-function(name){
  name<-gsub("\\$\\$([^\\$]+)\\$\\$", "\\\\deqn\\{\\1\\}", name, perl=TRUE)
  gsub("\\$([^\\$]+)\\$", "\\\\eqn\\{\\1\\}", name, perl=TRUE)
}

#used by rd.item
capitalizeIt<-function(name){
  gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", name, perl=TRUE)
}


asDot<-function(aName){
  gsub('[-:]','.', aName)
}

#' creates a location reference for a presentation attribute 
#' given the presentation attribute name 
getPresAttrsLoc<-function(presAttrs){ #USED in genPresAttrPages; ele2PresAttrs (elemDoc)
  #gsub("[-:]",".",presAttrs)->presAttrs #remove the uglies
  presAttrsLoc<-paste0(presAttrs,"-presentationAttribute")
  presAttrsLoc
}



loc2animDescription<-function(alink){
  tmp.DT<-ANIM.DT[loc==alink]
  if(nrow(tmp.DT)!=1){
    rtv<-NULL #maybe we should throw here?
  } else if( tmp.DT$anim[1]==FALSE ){
    print(alink)
    rtv<-c(
      rd.section("Animatable"),
      "Not Animatable"
    )
  } else if  (is.na(tmp.DT$additive)) {
    rtv<-NULL
  } else {
    ad<-tmp.DT$additive
    yn<-ifelse(ad,"Yes","No")
    a<-c(tmp.DT[1,animate],tmp.DT[1,set],tmp.DT[1,animateColor], tmp.DT[1,animateTransform])
    aa<-c("animate","set","animateColor","animateTransform")[a==TRUE]
    aa<-sapply(aa, nameWithLink) 
    aa<-paste(aa,collapse=", ")
    rtv<-c(
      rd.section("Animatable"),
      #rd.describe( aa ) ,
      paste("Using: ", aa, "."),
      paste("Supports Additive:", yn, ".")
    )
  }
  rtv
}



nameWithLink<-function(aName, aLink=NULL){
  if(is.null(aLink)){
    aLink<-aName
  }
  aName<-asDot(aName)
  #paste0("\\link[=", aLink,"]{",aName,"}")
  paste0("\\code{\\link[=", aLink,"]{",aName,"}}")
}

rd.code<-function(x){
  paste0("\\code{",x,"}")
}

rd.item<-function(x,y=""){
  paste0("\\item{", x, "}{", y,"}")
}

rd.comma<-function(x){
  paste0(x, collapse=", ")
}


rd.emph<-function(x){
  paste0("\\emph{",x,"}")
}
rd.describe<-function(x){
  c("\\describe{", x, "}")
}
rd.itemize<-function(x){
  c("\\itemize{", x, "}")
}
rd.name<-function(x){
  paste("@name",x)
}
rd.title<-function(x){
  paste("@title",x)
}
rd.aliases<-function(x){
  paste("@aliases",paste0(x,collapse=" "))
}
rd.section<-function(x){
  paste0("@section ",x,":")
}
rd.keywords<-function(x){
  paste0("@keywords ",x)
}
rd.description<-function(x){
  c("@description ",x)
}
rd.param<-function(param, param.def){
  paste("@param ", param, param.def, sep="   ")
}

rd.usage<-function(x){
  c("@usage", paste(x, collpase="; "))
}

rd.details<-function(x){
  c("@details",x)
}

rd.close<-function(xs){
  tmp<-paste0("#' ", xs ) 
  c(tmp,"NULL","\n")
}

