#' tron - Log an environment
#' 
#' Call \code{\link{.tron.environment}} on the package NAMESPACE
#' 
#' @param x an package
#' @param logger a logging function or name of function which accepts \code{...}
#' @param verbose logical, log which functions are detected and modified
#' 
#' @section Options:
#' You can set the following default parameters using \code{\link{option}}:
#' \describe{
#' \item{tron.logger}{ name of a logging function}
#' \item{tron.verbose}{ logical }
#' }
#' 
#' @rdname tron.character
#' @examples
#' f <- function(a,b) a / b
#' zzz <- function(x,y) f(x,y) / f(y,x)
#' tron(environment(), verbose=TRUE)
#' zzz(2,1)
.tron.character <- function(x,
                             logger=getOption("tron.logger", "message"),
                             verbose=getOption("tron.verbose", FALSE)){

  x <- asNamespace(x)
  unlock(x)
  lapply(ls(x), unlockBinding, x)
  .tron(x, logger, verbose)
}

#' @rdname tron.character
.troff.character <- function(x) {
  x <- asNamespace(x)
  .troff(x)
}

#' @useDynLib tron
unlock <- function(e) .C('unlock', e, PACKAGE='tron')
