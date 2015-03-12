

.onLoad <- function(libName,pkgName) {
browser()
   if(getOption("tron", FALSE) && requireNamespace("tron", quietly=TRUE)) {
     message("Using tron on ", pkgName)
     tron(parent.env(environment()))
   }
}
