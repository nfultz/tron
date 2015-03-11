#' tron - Automatic Logging
#'
#' This package provides a one-liner way to add logging to a function,
#' session, or an entire package.
#'
#' @author Neal Fultz \email{njf@@zestfinance.com}
#' @name tron
#' @aliases tron-package
#' @docType package
#' @seealso \code{\link{tron.function}}, \code{\link{tron.environment}}
NULL

# Attribute name for wrapped fns
.C = "tron";

# Package variable, used for tabbing function calls over
.a <- new.env(parent = emptyenv());
.a$depth = 0;

#' @export
#' @rdname tron
tron <- function(x, ...) UseMethod("tron")

#' @export
#' @rdname tron
untron <- function(x, ...) UseMethod("untron")

#' @rdname tron
#' @export
is.tron <- function(f)  identical(attr(f, .C), TRUE)

