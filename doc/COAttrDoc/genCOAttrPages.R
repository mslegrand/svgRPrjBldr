if(!exists("rd.name")){
  source("tableLoader.R")
  source("./doc/helpers/commonDoc.R")
}
if(!exists("els2Cats")){
  source("./doc/helpers/els2Cats.R")
}
if(!exists("validateString")){
  source("./doc/helpers/validateString.R")
}

#--------Combo Attribute Pages----------------------
requireTable(AVEL.DT, COP.DT, COAttrD.DT)
requireTable(AVEL.DT, ANC.DT)
# COP.DT is from comboParams.tsv 

#COAttrD.DT[attr=="in1", loc:=gsub("IN1","In",loc)]

genCOAttrPages<-function(){
  #helper fn
  
  co.loc2<-function(attr,loc, variable){
    sapply(1:length(attr), function(i){
      pattern<-paste0(attr[i],"Attribute$")
      pattern<-gsub("-","",pattern)
      variable<-paste0(toupper(variable[i]),'Attribute')
      variable<-gsub("-","",variable)
      sub(pattern, variable, loc[i], ignore.case=T)    
    }
    )   
  }
  
  
  #1. get the COLCL.DT data
  AL.DT<- AVEL.DT[, .(element, attr, loc)]
  #AL.DT[attr=="in1",attr:="in"]
  
  COP.DT[value=='in',value:='in1']
  setkey(COP.DT,element,value) # COP is element, variable, value, where variable=xy, value=x
  setkey(AL.DT,element,attr)
  COCL.DT<-
    AL.DT[COP.DT, .(
      element=element, 
      attr=variable, 
      component=value, 
      component.loc=loc
    )]
  # COCL.DT is element, attr,  component, component.loc
  # component.loc looks like "AltGlyphElementDXAttribute"
  

  
  COP.DT[,.SD[1,],by=list(element,variable)]->tmp1.DT
  setkey(tmp1.DT,element,value)
  #tmp1.DT=element,variable, value, where variable is xy, value is x (no y)
  # 
  #1.attr is an uncombined attr
  #2. loc is loc for attr
  #3. variable is combined attr
  COL.DT<-
    AL.DT[tmp1.DT, .(element=element, attr=variable, loc=co.loc2(attr, loc, variable))]
  # COL.DT is element, attr, loc
  # we lookup attr, loc in AL, and assign a new location via co.loc2 for each element, attr
  COLCL.DT<-
    merge(COL.DT,COCL.DT, by=c("element", "attr"))
  #COLCL.DT names are element" "attr"  "loc""component" "component.loc"
  # with 1 row for each component 
  
  COLCL2.DT<-COLCL.DT[,
    .( element=list(unique(element)),
       loc=list(loc),
       component=list(unique(component))
       ), by="attr"]
  #COLCL2.DT names are "attr"   "element"   "loc"       "component"
  # with 1 row for each attr , with element and component as vectors, 
  # but 1 loc: the loc of the combiner
  
  
  addAttributeEntry<-function(alink){
    # grab elements
    elements<-unique(COLCL.DT[loc==alink, element])
    elementsListing<-els2Cats(elements)

    the_attr<-unique(COLCL.DT[loc==alink,attr])
    title<-the_attr
    description<-COAttrD.DT[attr==the_attr,description]
    equivalence<-COAttrD.DT[attr==the_attr,equivalence]
    component<-unique(COLCL.DT[loc==alink,component])
    component.loc<-unique(COLCL.DT[loc==alink,loc])

    description<-validateString(description,"COAttrPg description")
    if(is.null(description)){description<-"To do"}
    
    txt<-c(
      rd.name(alink),
      rd.title(asDot(title)),
      rd.description(description),
      rd.section("Combines"),     
      rd.comma(nameWithLink(component, component.loc)),
      rd.section("Equivalence"),
      rd.describe(equivalence
      ),
      loc2animDescription(alink),
      if(!is.null(elementsListing)){
        c(rd.section("Used by the Elements"), 
        rd.describe( elementsListing ))
      } else {
        cat("Error in getCOAttrPages: empty elements")
        cat("alink=",alink,"\n")
        NULL
      },
      rd.keywords("internal")
    )
    tmp<-paste0(rd.close(txt) , collapse="\n" )
    tmp
  } #end addAttributeEntry
  
  #for each location, get the subtable, and process
  links<-unique(COLCL.DT$loc) # links are the links to each combo page
  attr.Pages.List<-lapply( links, addAttributeEntry)  
  rtv<-paste(attr.Pages.List,  collapse="\n")
  rtv 
}
