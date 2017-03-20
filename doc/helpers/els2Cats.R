if(!exists("requireTable")){
  library(data.table)
  source("tableLoader.R")
}
requireTable(EL2CAT.DT)

# requireTable(eaCS.DT, es.DT)
# # To get element category
# eaCS.DT[name %like% "elements",]->el2CatLookup.DT
# names(el2CatLookup.DT)<-c("category","element")
# other<-setdiff(unique(es.DT$element), el2CatLookup.DT$element )
# el2CatLookup.DT<-rbind(
#   el2CatLookup.DT,
#   data.table(category="Unclassified", element=other)
# )

els2Cats<-function(elements, notFound=NULL){
  #print(elements)
  elements.DT<-data.table(element=elements, loc=elements)
  elements.DT<-merge(elements.DT,EL2CAT.DT, by="element")
  
  if(nrow(elements.DT)>0){
    elements.DT[,linkTo:=nameWithLink(element)]
    elements.DT<-elements.DT[,.(element,linkTo),by=category] #group by category
    elements.DT<-elements.DT[, 
                             rd.item(
                               rd.emph(category), paste0(linkTo ,collapse=", ")
                             ),
                             by=category 
                             ]
    elementsListing<-elements.DT$V1
  } else {
    elementsListing<-notFound
  }
  elementsListing
}
