#' @section Component Mapping Algorithm Details:
#' The compononet Mappin Algoritms are as follows:
#' 
#' \itemize{
#' \item {\strong{identity}:
#' \itemize{
#'    \item{ To use specify 
#'       \itemize{
#'           \item{type='identity'}
#'       }
#'    } 
#'    \item{ Provides no mapping. In terms of color components, for each color component C, we have:
#'     \deqn{ C^{out}= C^{in}}
#'    } 
#' }}
#' \item{\strong{linear}
#'   \itemize{ Specified by
#'      \itemize{
#'         \item{type='linear'}
#'         \item{slope=<NUMERIC>} (default=1)
#'         \item{intercept=<NUMERIC>} (default=0)
#'      }
#'      \item{Maps the colors components using a linear function with the given slope and intercept.
#'       In terms of color components 
#'      \deqn{ C^{out}= m \times C^{in} + b} where \eqn{m} is given by the value of the slope attribute and
#'      \eqn{b} is given by the value of the intercept attribute.
#'       }
#'   }
#' }
#' \item{\strong{gamma}
#'   \itemize{ Specified by
#'     \itemize{
#'        \item{type='gamma'}
#'        \item{exponent=<NUMERIC>} (default=1)
#'        \item{amplitude=<NUMERIC>} (default=1)
#'        \item{offset=<NUMERIC>} (default=0)
#'     }
#'   }
#'   \item{ Maps the colors components non-linearly using a exponential function
#'    In terms of color components 
#'    \deqn{ C_{out}= A \times C_{in}^B +C} where,  
#'    A is given by the \emph{amplitute} attribute, B by the \emph{exponent} attribute and C but the \emph{offset} attribute.
#'   }}
#' \item {\strong{table}
#' \itemize{
#'     \item{Specified by
#'        \itemize{
#'           \item{type='table'}
#'           \item{table=<NUMERIC VECTOR>}
#'        }
#'     }
#'     \item Maps the colors components using a continous piece-wise linear function 
#'       defined by the \emph{valueTable} attribute. In terms of color components and a \emph{valueTable} attribute, v=c(v1,...,vn)
#'       for each color component \eqn{C^{in}}, we have:
#'       \deqn{C^{out}= v_k + m_k \times (v_{k+1}- v_k)}
#'       when \eqn{C^{in}<1} and where \eqn{k} and \eqn{m_k} are given by
#'       \deqn{k=floor(C^{in} \times n)}
#'       and 
#'       \deqn{m_k= C^{in} \times n mod(k) }
#'       In the case that  \eqn{C^{in}=1}, then we set \eqn{C^out=v_n}
#' }}
#' \item {\strong{discrete}
#' \itemize{
#'    \item{Specified by 
#'        \itemize{
#'           \item{type='table'}
#'           \item{table=<NUMERIC VECTOR>}
#'        }
#'     }
#'     \item {Maps the colors components using a  step function 
#'       defined by the \emph{valueTable} attribute. In terms of color components and a \emph{valueTable} attribute, v=c(v1,...,vn)
#'       for each color component \eqn{C^{in}}, we have:
#'       \deqn{C^{out}= v_k}
#'       when \eqn{C^{in}<1} and where k is given by
#'       \deqn{k=floor(C^{in} \times n)}
#'       In the case that  \eqn{C^{in}=1}, then we set \eqn{C^out=v_n}
#'       }
#' } }
#' }
