#' tron - Wrap a function in logging code
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
#' Wrapped functions carry a \dQuote{tron} attribute, which can be tested for
#' using \code{is.tron}. The original function \code{f} can be extracted
#' using \code{troff}.
#' 
#' 
#'
#' @seealso \url{http://en.wikipedia.org/wiki/Decorator_pattern} and  \code{\link[memoise]{memoise}} for another example of \dQuote{decorator} functions.
#' @export
#' @examples
#' f <- tron(sum, message)
#' f(1:10)
#' is.tron(f)
#' f <- troff(f)
#' f(1:10)
tron.function <- local({

    # static var for tabbing over.
    .a <- new.env(parent=emptyenv())
    .a$depth <- 0

    function(f, pre, post=pre) {

      # Bug 1: make sure f is forced, R is too lazy, it will infinitely recur
      # on the final function in the loop above if one function calls another.
      force(f);
      force(pre);
      force(post);
      
      structure( 
        function(...) {
          txt <- deparse(sys.call());
          
          .a$depth <- .a$depth + 1;
          
          on.exit({ .a$depth <- .a$depth - 1 })
          
          pre(Sys.time(), rep("\t", .a$depth), txt, " begin" );
          tmp <- f(...);
          post(Sys.time(), rep("\t", .a$depth), txt, " end");  
          tmp
        },
        tron=TRUE
      )
    }
})

#' @rdname tron.function
#' @export
troff.function <- function(f) {
  if(is.tron(f)) environment(f)$f else f
}

