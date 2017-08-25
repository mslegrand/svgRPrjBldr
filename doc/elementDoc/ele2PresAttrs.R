source("./doc/helpers/commonDoc.R")
requireTable(PA.DT)

ele2PresAttrs<-function(elName){
  presAttrs<-PA.DT[variable=="Applies to" & value==elName]$attr
  if(length(presAttrs)>0){
    presAttrs<-sort(presAttrs, decreasing = FALSE)
    #gsub("[-:]",".",presAttrs)->presAttrs #remove the uglies
    presAttrsLoc<-getPresAttrsLoc(presAttrs) #paste0("presAttrs.", presAttrs)      
    data.table(category="presentation attributes", attr=presAttrs, loc=presAttrsLoc)
  } else {
    NULL
  }
}
