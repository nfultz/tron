#' tron - x Log a session or package
#' 
#' Call \code{\link{.tron.function}} on each function in an environment and assign the result back.
#' 
#' @param x an environment to process; defaults to the \code{\link{.GlobalEnv}}
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
#' @section Logging a package:
#' 
#' If you would like to add logging to an entire package, add the following to \code{R/zzz.R} in your package:
#' \preformatted{   
#'   if(getOption("tron", FALSE) && require(tron)) tron(environment())
#' }
#' This will be run on package load and add logging to every function in the package, including 
#' non-exported functions. To activate it, 
#' \preformatted{
#'   options(tron=TRUE) # Set *before* you load the pkg
#'   library(mypkg)
#' }
#' @rdname tron.environment
#' @examples
#' f <- function(a,b) a / b
#' zzz <- function(x,y) f(x,y) / f(y,x)
#' tron(environment(), verbose=TRUE)
#' zzz(2,1)
.tron.environment <- function(x,
                             logger=getOption("tron.logger", "message"),
                             verbose=getOption("tron.verbose", FALSE)){
  logger <- match.fun(logger);
  t.e.impl(x,TRUE,verbose,"wrapping",tron, logger)
}

#' @rdname tron.environment
.troff.environment <- function(x) {
  verbose <- getOption("tron.verbose", FALSE);
  t.e.impl(x,FALSE,verbose,"unwrapping",troff)
}

# e - the environment
# M- a mask
t.e.impl <- function(e, M, verbose, label, ...) {
  R <- eapply(e, function(x) if(is.function(x) && xor(is.tron(x),M)) x)
  R <- Filter(Negate(is.null), R)
  if(isTRUE(verbose)) message(paste(label, names(R), '\n'))
  list2env(lapply(R,...), e)
  attr(e, "tron") <- M
}
