#---Stablize Root Directory -----------
# if necessary, set working director to base of project
getwd()->tmp
gsub("/svgRPrjBldr/.*","/svgRPrjBldr",tmp)->tmp #I assume svgRPrjBldr occurs exactly once in path
setwd(tmp)
#---------------------------

library(data.table)
if(!exists("requireTable")){ source("tableLoader.R") }

source("./code/specialTagHandlers.R")

#notess to self
#todo:
# add param processing to doc[['id']]: will need to consider tag that id belongs to or allow anything
# add param processing for use: same problem as #1, restricted to params for svg, symbol, g, graphics elements
# add param processing for animate: same problem as #1 restricted to animateable params
# all boil down to given reg attribute, preprocess, given pres attribute preprocess


# Some questions 
#1. how to add function completion:
# i) utils:::.addFunctionInfo(fn=c("cat","dog")) #note 3 colons
# ii)alternatively: 
#    pkgEnv = getNamespace("MyPackage")
#    attach(pkgEnv)


# Builds the svgFnQ stuff
build.svgFnQ<-function(){
 
  requireTable(AET.DT, COP1.DT, PA.DT)
# 
  
  AET.DT[AET.DT$attr=='tableValues',treatValueAs:='wsp-list']  #kludge for now, should add into dt soon!!!
  AET.DT<-rbind(AET.DT, #kludge for now, should add into dt soon!!!
        data.table(attr='values', element='feColorMatrix', anim=TRUE, treatValueAs="wsp-list"))
  
  # all elements
  ele.tags<-unique(AET.DT$element)
  #all attributes
  ele.tags.attributeName<-AET.DT[attr=="attributeName"]$element
  
  # here we get the special cases for our quotes
  attrsEle2Quote<-list(
    filter=c("g",PA.DT[attr=='filter' & variable=='Applies to']$value),
    fill=c("g",PA.DT[attr=='fill' & variable=='Applies to']$value),
    clip.path=c("g",PA.DT[attr=='clip-path' & variable=='Applies to']$value),
    mask=c("g",PA.DT[attr=='mask' & variable=='Applies to']$value),
    marker=c("g",unique(PA.DT[attr %like% "marker" & variable=='Applies to', value]))
  )
  
  # build list of all combos for potential animation
  COP1.DT[,.(variable,value)]->COP2.DT
  split(COP2.DT$value, COP2.DT$variable)->tmp
  lapply(tmp,unique)->aaCombos
  aaCombos[["in1"]]<-NULL
  
  #helper function
  centerable<-function(ele.tag, AET.DT){
    ifelse(
      nrow(AET.DT[  element==ele.tag & 
                      (attr=='x' | attr=='y' | attr=='width' | attr=='height') ,]
      )==4,
      "attrs<-mapCenteredXY(attrs)",
      ""
    )  
  }
  
  #helper function
  qcomboParamsFn<-function(etag){
    tmp<-COP1.DT[element==etag]
    if(nrow(tmp)>0){
      cp.list<-split(tmp$value, tmp$variable)
      # for each element of tmp.list, add the appropriate quote
      substitute(attrs<-comboParamHandler(attrs, cp ), list(cp=cp.list))
    } else {
      quote(NULL)
    }
  }
       
  createEleFnQ<-function(ele.tag, AET.DT){
    AET.DT[element==ele.tag & treatValueAs!="ignore",]->ele.dt
    ele.dt[, paste(attr, collapse=" "), by=treatValueAs]->treat_attrs.dt
    
    
    #helper fn
    # animateComboParam<-function(ele.tag){
    #   if(ele.tag %in% c("set","animate")){
    #     body0<-append(body0, makeAni(ele.tag, aaCombos) ,2)
    #   } else {
    #     NULL
    #   }
    # }
    
    
    #helper fn
    # insertCode4GivenTags insertCode4GivenTags
    insertCode4GivenTags<-function(ele.tag, ele.tag.set, fn, ...){
      if(ele.tag %in% ele.tag.set){
        fn(ele.tag, ...)
      } else {
        NULL
      }     
    }
    
    insertOnCondition<-function(condition, fn, ...){
      if(condition){
        fn(ele.tag, ...)
      } else {
        
      }
    }
    
    
    #helper fn
    echoQuote<-function(ele.tag, q){
      q
    }
    
  #Each fn body starts with
    body0<-c(
      quote( args <- list(...) ),
      quote( args <- promoteUnamedLists(args) ),
      insertCode4GivenTags(ele.tag,c('text' , 'textPath' , 'tspan'), insertTextNodeQuote),
      insertCode4GivenTags(ele.tag,c('set', 'animate'),makeAni, aaCombos),
      insertCode4GivenTags(ele.tag,'filter', echoQuote, filterTagQuote),
      quote( attrs <- named(args) ),
      insertCode4GivenTags(ele.tag,'feConvolveMatrix', echoQuote, feConvolveMatrixTagQuote)   
    )

  # body1 
  # call comboParamHandler combo params for given ele.tag
  # process elements which contain attributeName as an attribute
  # Insert special handling for animate element here
 
    body1<-list(
      qcomboParamsFn(ele.tag),
      if(nrow(AET.DT[element==ele.tag & (attr=='x' | attr=='y' | attr=='width' | attr=='height') ,])==4 ){
         quote(attrs<-mapCenteredXY(attrs) ) # append a call
      },
      insertCode4GivenTags(ele.tag, ele.tags.attributeName, echoQuote, quote(attrs<-mapAttributeName(attrs) ) ),
      insertCode4GivenTags(ele.tag, "animate", echoQuote, quote(attrs<-preProcAnimate(attrs)) )
      
    )
    body1[sapply(body1, is.null)] <- NULL  
    
    
  # body 2
  # add code to treat special lists, ie. comma list, space list, semicolon list ...
  # add quotes for special handling
    
    split(treat_attrs.dt, rownames(treat_attrs.dt))->tmp # (convert rows of treat_attrs.dt table to list)  
    preprocAttrValueFn<-function(tvaAttr){
      c(
        substitute( indx<-sapply(names(attrs),function(x)grepl(paste('(^| )',x,'($| )',sep=''), V1 )),tvaAttr),      
        substitute( if(length(indx)>0){ attrs[indx]<-lapply(attrs[indx], function(x){ svgPreproc[[treatValueAs]](x) })}, tvaAttr)
      )
    } 
    body2<-lapply(tmp, function(tvaAttr){preprocAttrValueFn(tvaAttr)}) 
    
    unlist(body2, use.names=F)->body2
    #as.list(body2)->body2


    body2<-c(body2, 
             quote(rtv<-list()), #rtv begins life here and is populated by the following
             insertCode4GivenTags(ele.tag,attrsEle2Quote$filter, echoQuote, filterQuote),
             insertCode4GivenTags(ele.tag,attrsEle2Quote$fill, echoQuote, fillQuote),
             insertCode4GivenTags(ele.tag,attrsEle2Quote$clip.path, echoQuote, clipPathQuote),
             insertCode4GivenTags(ele.tag,attrsEle2Quote$mask, echoQuote, maskQuote),
             insertCode4GivenTags(ele.tag,attrsEle2Quote$marker, echoQuote, markerEndQuote),
             insertCode4GivenTags(ele.tag,attrsEle2Quote$marker, echoQuote, markerMidQuote),
             insertCode4GivenTags(ele.tag,attrsEle2Quote$marker, echoQuote, markerStartQuote),
             insertCode4GivenTags(ele.tag, c('text' , 'textPath' , 'tspan'), echoQuote, textQuote),
             insertCode4GivenTags(ele.tag, c("linearGradient",  "radialGradient"), echoQuote, gradientColorQuote),
             insertCode4GivenTags(ele.tag, filterPrimitive.Tags, echoQuote, feQuote)          
    )
    
    body2[sapply(body2, is.null)] <- NULL

  #body 3
  # take care of children
  # if children are filterPrim, they will be prepended return value
  # return value has node as last entry with children prepend if necessary (i.e filterPrimitives)
    body3<-c(
      quote(kids<-allGoodChildern(args)),
      substitute(
        checkKids(kids, ele.tag), 
        list(ele.tag=ele.tag) ),
      substitute(
        node<-XMLAbstractNode$new(tag=ele.tag, attrs=attrs, .children=kids), 
        list(ele.tag=ele.tag)
      ),
      quote({ 
        if(length(rtv)>0){
          node<-c(rtv,node)
        }
        node
      })
    )

    body3[sapply(body3, is.null)] <- NULL
    

    fn<-function(...){}
    body(fn)<-as.call(c(as.name("{"), body0, body1, body2, body3))
    fn  
    
  }
  
  svgFnQ<-lapply(ele.tags, createEleFnQ, AET.DT=AET.DT )
  names(svgFnQ)<-ele.tags
  svgFnQ$script=script=function(...){
    args <- list(...)
    stopifnot( length(args)>0 , sapply(args, function(x)inherits(x,"character")))
    paste(args,collapse="\n")->js
    XMLScriptNode$new('script', attrs= list(type="application/ecmascript"),
          .children=list(XMLCDataNode$new(.children=as.list(js))  ))
  }
  #here we handle element names with -
  indx<-grep("-", names(svgFnQ))
  tmpFn<-svgFnQ[indx]
  names(tmpFn)<-gsub("-",".",names(tmpFn))
  svgFnQ<-c(svgFnQ, tmpFn,
    list(
      translate=function(dx,dy=NULL){
        if(length(c(dx,dy))!=2){
          base::stop("bad translate arguments")
        }
        list(translate=c(dx,dy))
      },
      rotate=function(angle, x=NULL, y=NULL){
        if(!(length(c(angle,x,y)) %in% c(1,3))){
          base::stop("bad rotate arguments")
        }
        list(rotate=c(angle,x,y))     
      },
      rotatR=function(angle, x=NULL, y=NULL){
        if(!(length(c(angle,x,y)) %in% c(1,3))){
          base::stop("bad rotate arguments")
        }
        tmp<-c(angle,x,y)
        tmp[1]<-as.numeric(tmp[1])*180/pi #convert from radians to degrees
        list(rotate=tmp)     
      },
      scale=function(dx,dy=NULL){
        if(!(length(c(dx,dy)) %in% 2)){
          base::stop("bad scale arguments")
        }
        list(scale=c(dx,dy))
      },
      skewX=function(angle){
        if(length(angle)!=1){
          base::stop("bad skewX arguments")
        }
        list(skewX=angle)
      },
      skewY=function(angle){
        if(length(angle)!=1){
          base::stop("bad skewY arguments")
        }
        list(skewY=angle)
      },
      u.em=function(x)paste0(x,'em'),
      u.ex=function(x)paste0(x,'ex'),
      u.px=function(x)paste0(x,'px'),
      u.pt=function(x)paste0(x,'pt'),
      u.pc=function(x)paste0(x,'pc'),
      u.cm=function(x)paste0(x,'cm'),
      u.mm=function(x)paste0(x,'mm'),
      u.in=function(x)paste0(x,'in'),
      u.prct=function(x)paste0(x,'%'),
      u.rad=function(x)x*180/pi 
    )
  )
  svgFnQ
}
# svgFnQ<-build.svgFnQ()


