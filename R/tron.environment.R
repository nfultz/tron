#' tron - x Log a session or package
#' 
#' Call \code{\link{tron.function}} on each function in an environment and assign the result back.
#' 
#' @param e an environment to process; defaults to the \code{\link{.GlobalEnv}}
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
#' @export
#' @examples
#' f <- function(a,b) a / b
#' zzz <- function(x,y) f(x,y) / f(y,x)
#' tron(environment(), verbose=TRUE)
#' zzz(2,1)
tron.environment <- function(e = .GlobalEnv,
                             logger=getOption("tron.logger", "message"),
                             verbose=getOption("tron.verbose", FALSE)){
  
  logger <- match.fun(logger);
  
  objNames <- ls(e);
  
  for(i in objNames) {
    x <- get(i, e);
    if(!is.function(x)) next;
    if(is.tron(x)) {
      if(verbose) logger("skipping\t", i);
      next
    }
    if(verbose)
      logger("wrapping\t", i);
    assign(i, tron(x, logger), envir=e);
  }

  attr(e, .C) <- TRUE
  
}

#' @export
#' @rdname tron.environment
untron.environment <- function(e) {

  verbose <- getOption("tron.verbose", FALSE);
  objNames <- ls(e);

  for(i in objNames) {
    x <- get(i, e);
    if(!is.function(x)) next;
    if(!is.tron(x)) {
      if(verbose) logger("skipping\t", i);
      next
    }
    if(verbose)
      logger("unwrapping\t", i);
    assign(i, untron(x), envir=e);
  }

  attr(e, .C) <- NULL

}
