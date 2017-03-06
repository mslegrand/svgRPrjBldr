library(data.table)

source("./tableLoader.R")

source("./commonDoc.R")
source("./helperFnsDoc.R")

requireTable(AET.DT)
requireTable( es.DT, eaCS.DT, PA.DT, COP.DT)

# replaces shape elements, descriptive elements, ... with the actual elements
expand.content.ele.names<-function(arg.names){
  arg.names<-gsub(":$","",arg.names)
  names<-unique(eaCS.DT$name)
  ele.cat.names<-names[grep("elements$",names)] # names are the categories of ele according to eaCS
  indx.cat<-match(arg.names, ele.cat.names, nomatch=0L)
  arg.ele.no.cat<-arg.names[indx.cat==0]
  arg.ele.cat<-arg.names[indx.cat>0]
  arg.ele.cat<-lapply(arg.ele.cat, function(x)sort(eaCS.DT[name==x]$value) )
  c(unlist(arg.ele.cat),arg.ele.no.cat)
}

expand.content.ele.names.esDT<-function(ele.content){
  #pick out those ending with colon to be expanded  
  catIndx<-grep("elements:", ele.content)
  if(length(catIndx)>0){
    regArgs<-ele.content[-catIndx]
    catArgs<-ele.content[catIndx]
    #1 remove s and colon at end
    catArgs<-gsub("s:$","",catArgs)
    #2 capitalize 1 letter of each word
    catArgs<-capitalizeIt(catArgs)
    #3 extract the elements in these categories
    expansion<-es.DT[variable=='category' & value %in% catArgs]$element
    rtv<-c(expansion,regArgs)
  } else{
    rtv<-ele.content
  }
  rtv
}

getContentElements<-function(eleName){
  # ---content.element handeling--------------
  elemArgs<-es.DT[element==eleName & variable=="content.model"]$value
  elemArgs1<-expand.content.ele.names.esDT(elemArgs)
  elemArgs2<-gsub("-",".",elemArgs1)
  if(eleName %in% c("text","tspan","textPath")){
    elemArgs1<-c(elemArgs1,"textData")
  }
  if(eleName=="script"){
    elemArgs1<-c(elemArgs1,"cData")
  }
  if(eleName=="feComponentTransfer"){
    elemArgs1<-c(elemArgs1, "feFuncA","feFuncR","feFuncB","feFuncG" )
  }
  sort(unique(c(elemArgs1,elemArgs2)))
}

do.content.elements<-function(composerFiles="svgR"){ 
  ele.tags<-sort(unique(AET.DT$element))
  
  contentE<-sapply(ele.tags, 
                   function(etag){
                     ce<-getContentElements(etag)
                     ce2<-gsub("[:-]",".",ce)
                     ce<-sort(unique(c(ce,ce2)))
                     ce
                   },  
                   simplify=FALSE)
  ind<-grep("[:-]", names(contentE))
  tmp<-contentE[ind]
  names(tmp)<-gsub("[:-]",".",names(tmp))
  contentE<-c(contentE,tmp)
  nm<-sort(names(contentE))
  contentE<-contentE[nm]
  txt<-deparse(
    substitute(
      contentElements<-contentE,
      env=list(contentE=contentE)
    )
  )
 
  cat(txt, file=paste(composerFiles, "eleContentElements.R", sep="/") )
}


do.content.elements()
