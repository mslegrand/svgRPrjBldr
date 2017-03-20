
#  ------------------------------------------------------------------------


#  ------------------------------------------------------------------------
library(data.table)
source("./tableLoader.R")
requireTable( es.DT, AVEL.DT, AVD.DT, eaCS.DT, PA.DT, COP.DT)

buildAll<-function(targetDir="svgR"){ 
#code
  # provides the  svgFnQ function list creator 
  source("./code/svgcreatoR.R") 
  # provides the follow fn for writing element defs to file
  source("./code/eleDefBldr.R")
  eleDefBldr(targetDir)
  
#documentation generation  
  source("./doc/docBldr.R") # entry point for documentmenation
  do.documentation(es.DT, targetDir) 

#lateX addon
  source("./code/TeXUnicodeBldr.R")
  TeXUnicodeBldr(targetDir)

}
buildAll()
