
#' Splits a given vector of elements into list of categories with both 
#' list names (category) and members( elements for each cat) sorted
#' 
#'  USED ONLY BY: elements.by.category.listing
extract.CatMember.List<-function(members, other="Unclassifed"){
  #expand??
  #other<-"Other"
  if(length(members)==0){
    tmp.list<-list()
  } else {
    rowNum<-match(members, eaCS.DT$value, nomatch=0L)
    missing<-members[rowNum==0]
    tmp.DT<-eaCS.DT[value %in% members]
    cats<-sort(unique(tmp.DT$name))
    if(length(missing)>0){
      cats<-c(cats,other)
      tmp.DT<-data.table(rbind(tmp.DT, data.table(name=other, value=missing)))
    } 
    tmp.list<-structure(lapply(cats, function(kit)tmp.DT[name==kit]$value) ,names=cats)
  } 
  tmp.list
}

eaCS2.DT<-eaCS.DT[,list("elements"=list(value)),by="name"]

eaCS.DT[name %like% "elements",]->el2CatLookup.DT
setorder(el2CatLookup.DT,name)


elements2categoryDF<-function( els ){
  el2CatLookup.DT[value %in% els, list(ele=list(sort(value))), by=name]->tmp.DT 
  other<-setdiff(els,el2CatLookup.DT$value)
  if(length(other)>0){
    tmp2.DT<-data.table(name="Unclassifed",ele=list(other))
    tmp.DT<-rbind(tmp.DT,tmp2.DT)
  }
  names(tmp.DT)<-c("category","element")
  tmp.DT
}

#eaCS.DT[name %like% "elements" & value %in% els, list(ele=list(sort(value))), by=name]->tmp.DT


#' uses: extract.CatMember.List
#' used by: 
#'    generate.element.pages::addElementEntry, 
#'    generate.Pres.Attr.Pages 
elements.by.category.listing<-function( elemArgs ){ #USED IN 3 PLACES: 
  elemArgs<-sort(unique(elemArgs))
  elemCats<-extract.CatMember.List(elemArgs, other="Unclassfied:")   
  
  elemCats<-lapply(elemCats, function(x){
    if(any(grepl('Empty', x))| any(grepl('Any element',x))){
      rd.code(x)
    } else {
      nameWithLink(x)
    }
  })
  
  elemArgsItems<-lapply(names(elemCats),function(category){
    rd.item(rd.emph(capitalizeIt(category)), paste(elemCats[[category]],collapse=", "))
  })
  
  unlist(elemArgsItems)->elemArgsItems   
}
