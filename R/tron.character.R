#' @rdname tron.environment
.tron.character <- function(x,
                             logger=getOption("tron.logger", "message"),
                             verbose=getOption("tron.verbose", FALSE)){

  x <- asNamespace(x)
  unlock(x)
  lapply(ls(x), unlockBinding, x)
  .tron(x, logger, verbose)
}

#' @rdname tron.environment
.troff.character <- function(x) {
  x <- asNamespace(x)
  .troff(x)
}

#' @useDynLib tron
unlock <- function(e) .C('unlock', e, PACKAGE='tron')
