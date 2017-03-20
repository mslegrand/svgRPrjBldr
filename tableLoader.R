
library(data.table)

tablesSrc=list(
  AVEL.DT="./dataTables/AVELTable.tsv",
  AVD.DT="./dataTables/AVDTable.tsv",
  es.DT="./dataTables/elementSummary.tsv",
  eaCS.DT="./dataTables/elementAttrCategorySummary.tsv",
  PA.DT="./dataTables/presentationAttr.tsv",
  COP.DT="./dataTables/comboParams.tsv",
  COP1.DT="./dataTables/comboParams.tsv",
  AET.DT="./dataTables/AETTable.tsv",
  PI.DT="./dataTables/propIndex.tsv",
  PAD.DT="./dataTables/PADescription.csv",
  RAD.DT="./dataTables/regAttrDescription.csv",
  ED.DT="./dataTables/elementDescription.csv",
  CEL.DT="./dataTables/catEleLookUp.csv",
  SPA.DT="./dataTables/specParams.csv",
  COAttrD.DT="./dataTables/COAttrD.csv",
  EL2CAT.DT="./dataTables/catEleLookUp.csv"
)

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



