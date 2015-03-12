#' @export
equipTron <- function() {
  zzz <- system.file(package="tron", "zzz.R")

  out <- file.path(getwd(), "R", "zzz.R")

  lapply(readLines(zzz), cat, "\n", file=out, append=TRUE)

  edit(file=out)

  invisible(TRUE)
}
