#' tron - Automatic Logging
#'
#' This package provides a one-liner way to add logging to an entire package or R session.
#'
#' @author Neal Fultz \email{njf@@zestfinance.com}
#' @name tron-package
#' @docType package
#' @seealso \code{\link{tron}}, \code{\link{wrap}}
NULL

# Attribute name for wrapped fns
.C = "tron";

# Package variable, used for tabbing function calls over
.a <- new.env(parent = emptyenv());
.a$depth = 0;

#' Automatic Logging
#' 
#' Call \code{\link{wrap}} on each function in an environment and assign the result back.
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
tron <- function(e = .GlobalEnv, logger=getOption("tron.logger", "message"), verbose=getOption("tron.verbose", FALSE)){
  
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
    assign(i, wrap(x, logger), envir=e);
  }
  
}


#' Wrap a function in logging code
#'
#' Create a logged copy of a function. Every time the new function is called, all three functions are called in order:
#' \enumerate{ 
#' \item \code{pre}
#' \item \code{f}
#' \item \code{post}
#' }
#'
#' @param f a function to decorate
#' @param pre a function, to be called before \code{f}
#' @param post a function, to be called after \code{f}
#'
#' @details
#' 
#' Wrapped functions carry an \dQuote{tron} class, which can be tested for using \code{is.tron}. The original function \code{f} can be extracted
#' using \code{unwrap}.
#' 
#' 
#'
#' @seealso \url{http://en.wikipedia.org/wiki/Decorator_pattern} and  \code{\link[memoise]{memoise}} for another example of \dQuote{decorator} functions.
#' @export
#' @examples
#' f <- wrap(sum, message)
#' f(1:10)
#' is.tron(f)
#' f <- unwrap(f)
#' f(1:10)
wrap <- function(f, pre, post=pre) {

  # Bug 1: make sure f is forced, R is too lazy, it will infinitely recur on the final function in the loop above if one function calls another.
  force(f);
  force(pre);
  force(post);
  
  #using `class<-` to keep local environment clean
  `attr<-`( 
    function(...) {
      txt <- deparse(sys.call());
      
      .a$depth <- .a$depth + 1;
      pre(Sys.time(), rep("\t", .a$depth), txt, " begin" );
      
      on.exit( {   
        post(Sys.time(), rep("\t", .a$depth), txt, " end");  
        .a$depth <- .a$depth - 1;
      })
      
      f(...);
    },
    .C, TRUE
  )
}

#' @rdname wrap
#' @export
is.tron <- function(f)  identical(attr(f, .C), TRUE)

#' @rdname wrap
#' @export
unwrap <- function(f) {
  if(is.tron(f)) environment(f)$f else f
}
