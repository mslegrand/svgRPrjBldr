if(!exists("rd.name")){
  library(data.table)
  source("tableLoader.R")
  source("./doc/helpers/commonDoc.R")
}
if(!exists("els2Cats")){
  source("./doc/helpers/els2Cats.R")
}
if(!exists("validateString")){
  source("./doc/helpers/validateString.R")
}

source("tableLoader.R")
requireTable(es.DT, ED.DT, eaCS.DT, COP.DT, PA.DT)
source("./doc/helpers/commonDoc.R")
source("./doc/elementDoc/esCM.R")
#source("./doc/helpers/genEleByCatListing.R")

source("./doc/elementDoc/ele2RegAttrs.R")
source("./doc/elementDoc/ele2COAttrs.R")
source("./doc/elementDoc/ele2PresAttrs.R")

# eaCS.DT[name %like% "elements",]->el2CatLookup.DT
# names(el2CatLookup.DT)<-c("category","element")
# other<-setdiff(unique(es.DT$element), el2CatLookup.DT$element )
# el2CatLookup.DT<-rbind(
#   el2CatLookup.DT,
#   data.table(category="Unclassified", element=other)
# )

#-----------------------------------------------------------------------------------------


#create an category element lookup to be used by elementContents
# cE.DT<-es.DT[variable=="category",list(ele=list(element)), by="value"]
# cE.DT<-cE.DT[,category:=paste0(tolower(value),"s:")]
# setorder(cE.DT,category)
# 
# getCM<-function(x){
#   i<-intersect(x,cE.DT$category)
#   x<-c(x,cE.DT[match(i, cE.DT$category),]$ele)
#   x<-setdiff(x,i)
#   unlist(x)
# }
# 
# es.DT[variable=="content.model",  list(content.model=list(value)), by=element]->esCM.DT
# esCM.DT[,contentM:=lapply(content.model, getCM)] #element-content.model expanded 
# 


#' generates element documentation  for each element found in es.DT
#' That is creates all individual element pages
#' 
genElementPages<-function(){
  #source('elementDescription.R')
  # ---------BEGIN HELPERS:generate.element.pages
  
  # replaces shape elements, descriptive elements, ... with the actual elements
  # expand.content.ele.names<-function(arg.names){
  #   arg.names<-gsub(":$","",arg.names)
  #   names<-unique(eaCS.DT$name)
  #   ele.cat.names<-names[grep("elements$",names)] # names are the categories of ele according to eaCS
  #   indx.cat<-match(arg.names, ele.cat.names, nomatch=0L)
  #   arg.ele.no.cat<-arg.names[indx.cat==0]
  #   arg.ele.cat<-arg.names[indx.cat>0]
  #   arg.ele.cat<-lapply(arg.ele.cat, function(x)sort(eaCS.DT[name==x]$value) )
  #   c(unlist(arg.ele.cat),arg.ele.no.cat)
  # }
  
  # expand.content.ele.names.esDT<-function(ele.content){
  #   #pick out those ending with colon to be expanded  
  #   catIndx<-grep("elements:", ele.content)
  #   if(length(catIndx)>0){
  #     regArgs<-ele.content[-catIndx]
  #     catArgs<-ele.content[catIndx]
  #     #1 remove s and colon at end
  #     catArgs<-gsub("s:$","",catArgs)
  #     #2 capitalize 1 letter of each word
  #     catArgs<-capitalizeIt(catArgs)
  #     #3 extract the elements in these categories
  #     expansion<-es.DT[variable=='category' & value %in% catArgs]$element
  #     rtv<-c(expansion,regArgs)
  #   } else{
  #     rtv<-ele.content
  #   }
  #   rtv
  # }

  #--------
  requireTable(AVEL.DT)

  # # input: elName, the name of an element
  # # return: attr-link-items of all  attrs, 
  # makeAttrLinkItems2<-function(elName){ #USED ONLY BY ELEMENT ADDENTRY
  #   
  #   #------gets the regular attributes and loc
  #   AL.DT<- AVEL.DT[element==elName, list(loc), key=attr] #attr loc
  #   #setkey(AL.DT, attr)
  #   #-----get categor for each attr
  #   setkey(eaCS.DT, value) #do just once please!!!
  #   CAL.DT<-eaCS.DT[AL.DT] 
  #   setnames(CAL.DT, c("category", "attr", "loc")) # "category", "attr", "loc"
  #   #some cleanup
  #   if(nrow(CAL.DT)>0){
  #     CAL.DT[is.na(category), category:='unclassified']
  #     CAL.DT[, attr:=gsub("[-:]", ".", attr)]
  #   } 
  #   #CAL.DT is a data.table of category, attribute location
  #   
  #   #-----combo attributes
  #   co.loc2<-function(attr,loc, variable){
  #     sapply(1:length(attr), function(i){
  #       pattern<-paste0(attr[i],"Attribute$")
  #       variable<-paste0(toupper(variable[i]),'Attribute')
  #       sub(pattern, variable, loc[i], ignore.case=T)    
  #     })   
  #   }
  #   
  #   # 1. get the combined attrs from COP.DT
  #   COP.DT[element==elName, .SD[1,], by=variable]->tmp1.DT      
  #   # 2. extract from AL.DT, the locations and form CAL.COP.DT for combined
  #   if(nrow(tmp1.DT)>0){
  #     setkey(tmp1.DT,value)
  #     #In one step :)
  #     CAL.COP.DT<-AL.DT[tmp1.DT,list(category='combining attributes', attr=variable, loc=co.loc2(attr, loc, variable))]
  #     setkey(CAL.COP.DT, attr) #make sure that it's sorted
  #     CAL.DT<-data.table(rbind(CAL.DT,CAL.COP.DT))        
  #   }
  #   
  #   #------presentation attributes
  #   presAttrs<-PA.DT[variable=="Applies to" & value==elName]$attr
  #   if(length(presAttrs)>0){
  #     #gsub("[-:]",".",presAttrs)->presAttrs #remove the uglies
  #     presAttrsLoc<-getPresAttrsLoc(presAttrs) #paste0("presAttrs.", presAttrs)      
  #     CAL.DT<-data.table(rbind(
  #       CAL.DT,
  #       data.table(category="presentation attributes", attr=presAttrs, loc=presAttrsLoc)
  #     ))  
  #   }
  # 
  #   # now put it all together
  #   if(nrow(CAL.DT)>0){
  #     setkey(CAL.DT, category, attr)
  #     CAL.LIST<-split(CAL.DT[, nameWithLink(attr, loc)] , CAL.DT$category)
  #     fn<-function(cat.name){
  #       rd.item(rd.emph(cat.name), paste0(CAL.LIST[[cat.name]], collapse=", ") )
  #     }
  #     attributesListing<-unlist(lapply(names(CAL.LIST), fn ))
  #   } else {
  #     attributesListing<-"{No Attributes Available}{!}"
  #   }
  #   attributesListing
  # } #end of makeAttrLinkItems2
  # 
  
  #helper fn to write doc for single element
  addElementEntry<-function(elName){
    description<-ED.DT[element==elName, "description"]
    title<-ED.DT[element==elName, "title"]      
    
    
    description<-validateString(description,"ElemPg description")
    if(is.null(description)){description<-"To do"}
    
    if(is.null(title)){
      title<-asDot(elName)
    }
    
    #showMe(elName)
    # ---content.element handeling--------------
      #elemArgs<-es.DT[element==elName & variable=="content.model"]$value
      #elemArgs<-expand.content.ele.names.esDT(elemArgs)
      # elemArgs are the content elements, i.e. elements that elName can take as parameters
      #elemArgs<-expand.content.ele.names(elemArgs) # replaces shape elements, ... with the actual elements 
      
      contentEle<-unlist(esCM.DT[element==elName,contentM])
      #print(contentEle)
      elementsListing<-els2Cats(elements=contentEle, notFound="{No Content Elements Applicable}{!}")
      
      # contentEle.DT<-data.table(element=contentEle, loc=contentEle)
      # contentEle.DT<-merge(contentEle.DT,el2CatLookup.DT, by="element")
      #elemArgsItems<- elements.by.category.listing(elemArgs) # break up elements back into el-categoris, but now is list
      #elByCat.DT<- elements2categoryDF(contentEle) # break up elements back into el-categories, but now is list
      
    #--- attribute  handling---------------------------------------   
      regAttrs.DT<- ele2RegAttrs(elName)
      coAttrs.DT<-  ele2COAttrs(elName)
      presAttrs.DT<-ele2PresAttrs(elName)
      attr.DT<-rbind(regAttrs.DT,coAttrs.DT,presAttrs.DT)
      if(nrow(attr.DT)>0){
        attr.DT[,linkTo:=nameWithLink(attr,loc)]
        attrGrp.DT<- #group by category
          attr.DT[, 
                  rd.item(
                    rd.emph(capitalizeIt(category)), paste0(linkTo ,collapse=", ")
                  ),
                  by=category 
                  ]
        setorder(attrGrp.DT,category)
        attributesListing<-attrGrp.DT$V1
      } else {
        attributesListing<-"{No Attributes Available}{!}"
      }
      
      #if(nrow(contentEle.DT)>0){
        
        #attr.DT[,linkTo:=nameWithLink(attr,loc)]
      #   contentEle.DT[,linkTo:=nameWithLink(element)]
      #   contentEle.DT<- #group by category
      #     contentEle.DT[, 
      #             rd.item(
      #               rd.emph(category), paste0(linkTo ,collapse=", ")
      #             ),
      #             by=category 
      #             ]
      #   contentElementsListing<-contentEle.DT$V1
      # } else {
      #   contentElementsListing<-"{No Content Elements Applicable}{!}"
      # }
      #attrArgsItems<-makeAttrLinkItems2(elName)   #requries AVEL.DT
      
    #---pulling it together 
    txt<-c(
      #name
      rd.name(elName), 
      #title
      rd.title(title), 
      if(asDot(elName)!=elName){
        rd.aliases(asDot(elName))
      } else{
        NULL
      },
      #description
      rd.description(description),
      #attributes
      rd.section("Available Attributes (Named Parameters)" ),
      
      rd.describe(attributesListing),
      # content Elements
      rd.section("Available Content Elements (Unnamed Parameters)" ),
      rd.describe(elementsListing),
      #keywords
      rd.keywords("element")
    )
    txt<-paste0(rd.close(txt),collapse="\n")
    txt
  } #END: addElementEntry
  
  # ---------END HELPERS:generate.element.pages
  
  #vector of all elements
  unique(es.DT$element)->all.elements
  # content.DT
  #es.DT[variable=="content.model", list(content=list(I(.I))), by=element]->content.DT
  #es.DT[variable=="content.model",list(element,value)]->content2.DT

  #es.DT[variable=="attr",  list(attr=list(I(.I))), by=element]->attributes.DT
  
  eleL<-lapply( all.elements, addElementEntry)
  rtv<-paste(eleL,collapse="\n")
  
} 
#----------- END: generate.element.pages
