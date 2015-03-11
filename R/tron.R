#' tron - Automatic Logging
#'
#' This package provides a one-liner way to add logging to an entire package or R session.
#'
#' @author Neal Fultz \email{njf@@zestfinance.com}
#' @name tron-package
#' @docType package
#' @seealso \code{\link{tron}}, \code{\link{untron}}
NULL

# Attribute name for wrapped fns
.C = "tron";

# Package variable, used for tabbing function calls over
.a <- new.env(parent = emptyenv());
.a$depth = 0;


#' @rdname tron
#' @export
is.tron <- function(f)  identical(attr(f, .C), TRUE)

#' @rdname tron.function
#' @export
untron.function <- function(f) {
  if(is.tron(f)) environment(f)$f else f
}

untron.environment <- function(e) {

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
