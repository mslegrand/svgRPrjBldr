requireTable(es.DT)



#create an category element lookup to be used by elementContents
cE.DT<-es.DT[variable=="category",list(ele=list(element)), by="value"]
cE.DT<-cE.DT[,category:=paste0(tolower(value),"s:")]
setorder(cE.DT,category)

getCM<-function(x){
  i<-intersect(x,cE.DT$category)
  x<-c(x,cE.DT[match(i, cE.DT$category),]$ele)
  x<-setdiff(x,i)
  unlist(x)
}

es.DT[variable=="content.model",  list(content.model=list(value)), by=element]->esCM.DT
esCM.DT[,contentM:=lapply(content.model, getCM)] #element-content.model expanded 

