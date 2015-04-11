#' Equip a package with tron
#'
#' Adds a tron startup hook to a packages \code{.onLoad} and \code{DESCRIPTION}.
#' Run this from a package's source root directory.
#'
#' @export
equipTron <- function() {
  message("Adding tron hook to R/zzz.R")
  zzz <- system.file(package="tron", "zzz.R")
  out <- file.path(getwd(), "R", "zzz.R")
  cat(readLines(zzz), sep="\n", file=out, append=TRUE)

  message("Adding tron to DESCRIPTION")
  cat("Suggests: tron", sep="\n", file="DESCRIPTION", append=TRUE)

  invisible(TRUE)
}
