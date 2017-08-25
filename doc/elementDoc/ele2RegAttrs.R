requireTable(AVEL.DT, eaCS.DT)

ele2RegAttrs<-function( elName ){
  #------gets the regular attributes and loc
  AL.DT<- AVEL.DT[element==elName, list(loc), key=attr] #attr loc
  #setkey(AL.DT, attr)
  #-----get categor for each attr
  setkey(eaCS.DT, value) #do just once please!!!
  CAL.DT<-eaCS.DT[AL.DT] 
  setnames(CAL.DT, c("category", "attr", "loc")) # "category", "attr", "loc"
  #some cleanup
  if(nrow(CAL.DT)>0){
    CAL.DT[is.na(category), category:='unclassified']
    CAL.DT[, attr:=gsub("[-:]", ".", attr)]
  } 
  #CAL.DT is a data.table of category, attribute location
  CAL.DT
}