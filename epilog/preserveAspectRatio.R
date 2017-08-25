#' @section Details: 
#' A preserveAspectRatio value is a vector, which consists of mandatory alignment directive, possibly prepended with an optional defer directive and possibly
#' postpended with an optional meet-or-slice directive.
#' 
#' **The Align Directives** (mandatory, pick one)
#' \tabular{ll}{
#' xMinYMin  \tab Place the viewBox in the top-left hand corner of the viewport, and force uniform scaling. \cr
#' xMidYMin  \tab Place the viewBox at the top of the viewport and center it horizontally with respect to the viewport, and force uniform scaling. \cr
#' xMaxYMin  \tab Place the viewBox at the top-left hand corner of the viewport, and force uniform scaling. \cr
#' xMinYMid   \tab Place the viewBox to be centered at the left edge of the viewport, and force uniform scaling. \cr
#' xMidYMid   \tab Place the viewBox to be centered at the center of the viewport, and force uniform scaling. This is the default. \cr
#' xMaxYMid  \tab Place the viewBox to be centered at the right edge of the viewport, and force uniform scaling. \cr
#' xMinYMax  \tab Place the viewBox at the lower-left hand corner of the viewport, and force uniform scaling. \cr
#' xMidYMax  \tab Place the viewBox at the center of the bottom edge of the viewport, and force uniform scaling. \cr
#' xMaxYMax  \tab Place the viewBox at the lower-lright hand corner of the viewport, and force uniform scaling.\cr
#' none  \tab Scale the graphics so that the viewBox coinsides with the viewport and ignore any meet or slice directives. 
#' }
#' (Note: if <align> is none, then the optional <meetOrSlice> value is ignored.)
#' 
#' **The Meet-o-Slice Directives** (optional)
#' \tabular{ll}{
#' meet \tab Directive to scale up the graphic  as  such that the resulting viewBox is still contained within the viewPort, while still maintaining the original the aspect ratio. \cr
#' slice \tab Directive to scale up the graphic as  such that the resulting viewBox just covers the viewPort, while still maintaining the original the aspect ratio. 
#' }	
#' 
#' **The Defer Directive** (optional):
#' \tabular{ll}{
#' defer \tab Directive to instruct that any 'peserveAspectRation' value set in the content takes precedence.
#' }

