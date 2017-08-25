#' @section Details:
#' A \strong{transform-list} is named list of coordinate transforms to be applied in the order in which they appear. 
#' For example:
#' \code{ list(translate=c(100,20), scale=1.2, rotate=c(30,100,20))}
#' The list names and 
#' corresponding values (all numeric)
#' are summarized in the following table
#' **Transforms**
#' \tabular{lll}{
#' name     \tab value  \tab action \cr
#' matrix   \tab  a 2x3 matrix m. \tab Transforms coordinates x,y to x'y' by c(x',y',1)<-m \%*\% c(x,y,1), where m'<-rbind(m,c(0,0,1). \cr
#' translate \tab x or c(x,y) \tab Translates by c(x, y). If only x is specified, y is set to 0. \cr
#' scale     \tab sx or c(sx, sy) \tab Scales by sx, sy. If only sx is specified, sy=sx. \cr
#' rotate    \tab $\theta$ or c( $\theta$,x,y). \tab Rotates by theta degrees about the point c(x,y). If only the  $\theta$ is specified, then x=y=0. \cr
#' skewX    \tab $\theta_x$ \tab Skews along the x-axis by an angle of $\theta_x$ , where $\theta_x$ is interpreted in units of degrees.\cr
#' skewY    \tab $\theta_y$  \tab Skews along the y-axis by an angle of $\theta_y$ , where $\theta_y$ is interpreted in units of degrees.\cr
#' }

