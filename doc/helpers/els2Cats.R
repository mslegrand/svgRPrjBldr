if(!exists("requireTable")){
  library(data.table)
  source("tableLoader.R")
}
requireTable(EL2CAT.DT)


els2Cats<-function(elements, notFound=NULL){
  #print(elements)
  elements.DT<-data.table(element=elements, loc=elements)
  elements.DT<-merge(elements.DT,EL2CAT.DT, by="element")
  setorder(elements.DT,element)
  if(nrow(elements.DT)>0){
    elements.DT[,linkTo:=nameWithLink(element)]
    elements.DT<-elements.DT[,.(element,linkTo),by=category] #group by category
    elements.DT<-elements.DT[, 
                             rd.item(
                               rd.emph(category), paste0(linkTo ,collapse=", ")
                             ),
                             by=category 
                             ]
    setorder(elements.DT,category)
    elementsListing<-elements.DT$V1
  } else {
    elementsListing<-notFound
  }
  elementsListing
}
