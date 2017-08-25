
library(data.table)


tablesSrc=list(
  ANIM.DT="./dataTables/ANIM.csv",
  AVEL.DT="./dataTables/AVELTable5.csv",
  AVD.DT="./dataTables/AVD60.csv", #"./dataTables/AVD41Table.csv", #AVD.DT="./dataTables/AVDTable.tsv",
  es.DT="./dataTables/ES.csv",
  eaCS.DT="./dataTables/elementAttrCategorySummary.tsv",
  PA.DT="./dataTables/PA.csv", #"./dataTables/presentationAttr.tsv",
  COP.DT="./dataTables/COP.csv",
  COP1.DT="./dataTables/COP1.csv",
  AET.DT="./dataTables/AETTable.tsv", # svgcreatoR
  
  PAD.DT="./dataTables/PADescription3.csv",
  
  ED.DT="./dataTables/ED4.csv", #"./dataTables/elementDescription.csv",
  CEL.DT="./dataTables/catEleLookUp.csv",
  
  
  COAttrD.DT="./dataTables/COAttrD.csv", # getCOAttrPages.R
  EL2CAT.DT="./dataTables/catEleLookUp.csv", #ele2Cats.R
  
  PAV.DT="./dataTables/PAV_EDITED12.csv", 
  RAF.DT="./dataTables/RAF18.csv",
  PROLOG.DT="./dataTables/PROLOG6.csv",
  EPILOG.DT="./dataTables/epilog5.csv",
  ANC.DT="./dataTables/Ancillary10.csv" #,
  
  # ADJ.DT="./dataTables/adjCO.csv", #only here!
  # PI.DT="./dataTables/propIndex.tsv", #only here
  # RAD.DT="./dataTables/regAttrDescription.csv", # only here
  # SPA.DT="./dataTables/specParams.csv", # only here (or makeAdjunctiveTable)
  # SPACXY.DT="./dataTables/specParamsCXY.tsv", #only here
)

#temporary kludge for keeping epilog current
updateEpilog<-function(){
  n1<-dir("./epilog/")
  lookupKey<-gsub(".R$","",n1)
  #requireTable(EPILOG.DT)
  #EPILOG.DT[,lookupKey]->n2
  files<-paste0("./epilog/",n1)
  aList<-sapply(files, function(x){
    #cat(x,"\n")
    paste0(readLines(x),collapse="")
  } )
  epilog.DT<-data.table(lookupKey=lookupKey, value=aList)
  fwrite(x = epilog.DT, file = tablesSrc[["EPILOG.DT"]], sep="\t")
}

updateEpilog()

#~ usage:  
#~ requireTable(AVD.DT, eaCS.DT)
requireTable<-function(...){
  tmp<-deparse(sys.call())
  tmp<-gsub("requireTable\\(","",tmp)
  tmp<-gsub("[\\(\\)\'\"]","",tmp)
  dtNames<-strsplit(tmp, "[ ,]+")[[1]]
  if(!is.null(dtNames)){
    lapply(dtNames,
           function(name){
             if(!exists(name)){
               if(!(name%in%names(tablesSrc))){
                 cat(paste("Cannot find path for data.table='", name,"'\n"))
                 #stop(paste("Cannot find path for data.table='", name,"'\n"))
               } else{
                 path<-tablesSrc[[name]]
                 cl<-substitute(fread(path, showProgress=FALSE )->>name, list(path=path, name=name))
                 eval(cl, env=parent.frame() )        
               }
             }
           })    
  }
  invisible('')
}



