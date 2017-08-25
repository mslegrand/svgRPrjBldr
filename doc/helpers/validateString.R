# returns NULL up failure.
validateString<-function(str, mssg=" PAD.DT"){
  if(length(str)==0){
    str<-NULL
    #print(paste(attribute, mssg))
    print(paste("NULL STRING ERROR:",mssg, collapse=" "))
  } else {
    str<-trimws(str)
    if(nchar(str)==0){
      str<-NULL
      #print(paste("Invalid description: ", attribute, "in PAD.DT"))
      print(paste("0 LENGTH STRING ERROR:", mssg, collapse=" "))
    }
  }
  str
}
