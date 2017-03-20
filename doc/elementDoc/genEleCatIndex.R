
#' Generates a Listing of all elements by category  (Index of Ele Cats)
genEleCatIndex<-function(){ 
  oneCatListing<-function(category){
    #for a given category extracts the elements and
    #returns a section with category title and element listing
    es.DT[variable=="category" & value==category]$element->ele    
    sort(ele)->ele
    res<-c(
      rd.section( paste0(category,"s") ),
      rd.describe( rd.item( nameWithLink(ele) ) )
    )
  } 
  
  #categories are identified by es.DT
  cats<-unique(es.DT[variable=="category"]$value)
  cats<-sort(cats)
  # Element Group Name
  cat.index<-sapply(cats, oneCatListing)
  cat.index<-unlist(cat.index)
  cat.index<-c(
    cat.index,
    rd.name('Element Index'),
    rd.title('Element Generators Indexed by Category'),
    rd.description('This is a listing by category of generators to use when generating an svg markup.')
  ) 
  paste0(rd.close(cat.index), collapse="\n")
}
