#' Automatic Logging
#'
#' @name autolog-package
#' @docType package
NULL

# Class name for wrapped fns
.C = "autologger";

# Package variable, used for tabbing function calls over
.a <- new.env(parent = emptyenv());
.a$depth = 0;

#' Automatic Logging
#' 
#' @param e an environment to process; default to Global
#' @param logger a logging function accepting \code{...}
#' @param verbose verbose output of what functions are being instrumented
#' 
#' @export
#' @examples
#' f <- function(a,b) a / b
#' zzz <- function(x,y) f(x,y) / f(y,x)
#' autolog(environment(), verbose=TRUE)
#' zzz(2,1)

autolog <- function(e = .GlobalEnv, logger="message", verbose=getOption("autolog.verbose", FALSE)) {
  
  logger <- match.fun(logger);
  
  objNames <- ls(e);
  
  for(i in objNames) {
    x <- get(i, e);
    if(!is.function(x)) next;
    if(class(x) == .C) {
      if(verbose) logger("skipping\t", i);
      next
    }
    if(verbose)
      logger("wrapping\t", i);
    assign(i, wrap(x, logger), e);
  }
  
  e$.AUTOLOG <- TRUE;
}



wrap <- function(x, logger) {

  # Bug 1: make sure x is forced, R is too lazy, it will infinitely recur on the final function in the loop above if one function calls another.
  force(x);
  force(logger);
  
  #using `class<-` to keep local environment clean
  `class<-`( 
    function(...) {
      txt <- deparse(sys.call());
      
      .a$depth <- .a$depth + 1;
      logger(Sys.time(), rep("\t", .a$depth), txt, " enter" );
      
      on.exit( {   
        logger(Sys.time(), rep("\t", .a$depth), txt, " exit");  
        .a$depth <- .a$depth - 1;
      })
      
      x(...);
    },
    .C
  )
}

unwrap <- function(x) {
  if(class(x) == .C) environment(x)$x else x
}
