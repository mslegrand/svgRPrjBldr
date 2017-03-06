# other helper functions
generateHelperDoc.Pages<-function(){
  l1.names<-c('translate','rotate','rotateR','scale')
  l1.title<-sapply(l1.names, function(x) 'Helper for tranform', simplify = FALSE)
  l1.keyword<-sapply(l1.names, function(x) 'transform helper', simplify = FALSE)
  
  l1.description=c(
    translate=  'Used as an value for the transform attribute. Translates the target by an amount given by dx, dy',
    rotate=     'Used as an value for the transform attribute. Rotates the target by an amount given by angle, where angle is in degrees. Center of rotation is x,y',
    rotateR=    'Used as an value for the transform attribute. Rotates the target by an amount given by angle, where angle is in radians. Center of rotation is x,y',
    scale=      'Used as an value for the transform attribute. Scales the target by an amount given by dx, dy'
  )
  
  l1.details<-sapply( l1.names, function(x){paste( "The", x, "helper function is to be used only as value for the transfrom attribute. It can be used alone or in conjunction
  the other transform helper functions. Some examples are:")}
  , simplify = FALSE)
  
  l1.use<-list(
    translate = c("transform=translate(x,y)", "transform=translate(c(x,y))", "transform=c(translate(x,y), rotate(a,cx,cy), scale(sx,sy"),
    rotate    = c("transform=rotate(90,400,100)"),
    rotateR   = c("transform=rotate(pi/2,400,100)"),
    scale     = c("transform=scale(x,y)", "transform=scale(c(x,y))",  "transform=c(scale(x,y),  translate(sx,sy")
  )
  
  l1.params<-list(
    translate = list(dx="Change in x coordinate for translation", dy="Change in y coordinate for translation"),
    rotate    = list(angle="Rotation angle in degrees", x="fixed point x coordinate", y="fixed point y coordinate"),
    rotateR   = list(angle="rotation angle in radians", x="fixed point x coordinate", y="fixed point y coordinate"),
    scale     = list(dx="change of scale in the x direction", dy="change of scale in the y direction")
  )
  
  
  l2.names<-c( "u.em", "u.ex", "u.px", "u.pt", "u.pc", "u.cm", "u.mm", "u.in", "u.prct", "u.rd")
  l2.title<-sapply(l2.names, function(x) "Helper function to declare units", simplify = FALSE)
  l2.keyword<-sapply(l1.names, function(x) 'units helper', simplify = FALSE)
  
  l2.description<-c(
    "Declares the units to be em's. (An em isa  measure relative to current font size)",
    "Declares the units to be ex's. (An ex is a measure relative to the height of the character x)",
    "Declares the units to be pixels.",
    "Declares the units to be points's. (1pt=1/72 inch)",
    "Declares the units to be pica's. (1pc=1/6 inch)",
    "Declares the units to be centimeters (cm)",
    "Declares the units to be millimeters (mm)",
    "Declares the units to be inches (in)",
    "Declares the units to be percentage (\\%)",
    "Declares the units to be radians"
  )
  names(l2.description)<-l2.names
  
  l2.details<-sapply( l1.names, function(x){paste( "This helper function is a simple convenience to add units to a value of a named parameter. Some examples are:")}
                      , simplify = FALSE)
  
  l2.use=list(
    "transform=translate(u.em(c(0,2))",
    "transform=translate(u.ex(c(0,2))",
    "transform=translate(u.px(c(0,2))",
    "transform=translate(u.pt(0,36))",
    "transform=translate(u.pc(0,3))",
    "transform=translate(u.cm(0,2)",
    "transform=translate(u.mm(0,20)",
    "transform=translate(u.in(0,.5)",
    "viewBox=u.\\%(c(0,0,50,50))",
    "transform=rotate(u.rd(pi/2), 100,100)"
  )
  names(l2.use)<-l2.names
  
  l2.params<-list(
    list(x="value in em "),
    list(x="value in ex "),
    list(x="value in pixels (default)"),
    list(x="value in points (pt) "),
    list(x="valus in picas (pc)"),
    list(x="value in centimeters (cm)"),
    list(x="value in millimeters (mm)"),
    list(x="value in inches (in)"),
    list(x='value as a percentage (\\%)'),
    list(x='value in radians') 
  )
  names(l2.params)<-l2.names
  
  names<-c(l1.names, l2.names)
  titles<-c(l1.title, l2.title)
  descriptions<-c(l1.description, l2.description)
  uasages<-c(l1.use, l2.use)
  parameters<-c(l1.params, l2.params)
  keywords<-c(l1.keyword, l2.keyword)
    
  tmp<-lapply(names, function(name){
    param<-names(parameters[[name]])
    param.def<-unlist(parameters[[name]])
    tmp<-c( rd.name(name),
            rd.title(titles[name]),
            rd.param(param, param.def),
            rd.description(descriptions[name]),
            #rd.details(usesages[name]),
            rd.itemize(rd.item( uasages[[name]])),
            rd.keywords(keywords[name])
    )
    rd.close(tmp)
  })
  
  tmp<-unlist(tmp)
  tmp<-paste(tmp, collapse="\n")
  tmp
}
