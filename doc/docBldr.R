# good read: http://www.quantumvibe.com/strip?page=1

#ghost docs
#todo!!! 
# add cxy, ... and other custom attributes (i.e for gradient)
# add alias for . and - and :  elements
# add alias for . and - (and :? ) attributes
# add description
# add meaningful titles
# rename element categories (ends and refererences ending with :)
# add categories for attributes (such as presentation, ...)
# implement the name completions in .onload
# add a main category page
# add example docs
# check if we still need an alias for add attribute entry
# compare avel with attr


# todo!!! 
# save docs to link to svgComposer
# save source to link to svgComposer
# use svgComposer in svgShiny
# write examples!!!

#testing 123
library(data.table)
source("./tableLoader.R")
source("./doc/helpers/commonDoc.R")
source("./doc/genHelperDocPages.R")

requireTable( es.DT, eaCS.DT, PA.DT, COP.DT, AVD.DT, AVEL.DT, COP.DT)

#buildDocumentation

#------------------------ATTENTION!!!!-----------------------------------------
# tmp kludge to remove the presentation attrs
#------------------------BEGIN KLUDGE!!!!-----------------------------------------
eaCS.DT[name!="presentation attributes"]->eaCS.DT
#rbind(eaCS.DT, data.table(name="presentation attributes", value="alignment-baseline"))
#------------------------END KLUDGE!!!!-----------------------------------------


# requires es.DT, AVEL.DT, AVD.DT,
do.documentation<-function(es.DT, composerFiles="svgR"){ 
  source('./doc/elementDoc/genElemDocPages.R')
  source('./doc/elementDoc/genEleCatIndex.R')
  #source("./doc/genAttrDocPages.R")
  source("./doc/regAttrDoc/genRegAttrPages.R")
  source("./doc/COAttrDoc/genCOAttrPages.R")
  source("./doc/presAttrDoc/genPresAttrPages.R")
  
  #listing of Elements by Categories
  ele.cat.indx<-genEleCatIndex()
  cat( ele.cat.indx, file=paste(composerFiles, "doc_EleCatIndxPage.R", sep="/") )
  
  #individual element documentation
  ele.pages<-genElementPages()
  cat(ele.pages, file=paste(composerFiles, "doc_ElePages.R", sep="/") )

  #regular attribute documentation
  regAttrDocPages<-genRegAttrPages()
  cat(regAttrDocPages, file=paste(composerFiles, "doc_RegAttrPages.R", sep="/") )

  #presentation Attributes
  presAttrDocPages<-genPresAttrPages()
  cat(presAttrDocPages, file=paste(composerFiles, "doc_PresAttrPages.R", sep="/") )

  #comboAttrDocPages
  combAttrDocPages<-genCOAttrPages()
  cat(combAttrDocPages, file=paste(composerFiles, "doc_CombAttrPages.R", sep="/") )
  
  
  # helperFnDocPage
  helperDocPage<-genHelperDocPages()
  cat(helperDocPage, file=paste(composerFiles, "doc_HelperPages.R", sep="/") )
#attr doc
  #attrDefDoc<-get.Attr.defs(es.DT)
  #cat(attrDefDoc, file=paste(composerFiles, "attrDefDoc.R", sep="/") ) 
}

do.documentation(es.DT)
