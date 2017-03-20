library(data.table)

# Builds eleDefs.R file containing the eleDefs
writeEleDefs<-function(svgFnQ, targetDir="svgR"){
   tmp<-paste(deparse(svgFnQ),collapse="\n")
   tmp3<-gsub('}, ', "}, \n",tmp)
  desc<-
"# About:
# The code in this file was programmiclly generated.
# The program responsible can be found at
# https://github.com/mslegrand/svgcomposeR_PrjBlder
#
"
  cat(desc,"eleDefs<-\n",tmp3, 
      file=paste(targetDir,"eleDefs.R", sep="/"))
  invisible(NULL)
}

writeElements<-function(svgFnQ, targetDir="svgR"){
  fnName<-names(svgFnQ)
  indx<-grep("-", fnName)
  fnName[indx]<-paste0('"',fnName[indx],'"')
  
  desc<-
"# About:
# The code in this file was programmiclly generated,
# the program responsible can be found at
# https://github.com/mslegrand/svgcomposeR_PrjBlder
#
"
  txt<-lapply( 1:length(svgFnQ), function(i){
      fnTxt<-paste0(deparse(svgFnQ[[i]]),collapse="\n")
      fnTxt<-paste0(fnName[i],"<-",fnTxt)
  } )
  txt<-unlist(txt)
  txt<-c(desc, txt)
  txt<-paste(txt,  collapse="\n\n")
  cat( txt, file=paste(targetDir,"elements.R", sep="/") )
  invisible(NULL)
}
    


eleDefBldr<-function( targetDir="svgR"){
  svgFnQ<-build.svgFnQ()
  writeEleDefs(svgFnQ,targetDir)
  writeElements(svgFnQ,targetDir)
}
 