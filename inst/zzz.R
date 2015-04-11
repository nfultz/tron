
# This will activate tron on a whole package
.onLoad <- function(libName,pkgName) {
   if(getOption("tron", FALSE) && requireNamespace("tron", quietly=TRUE)) {
     packageStartupMessage("Using tron on ", pkgName)
     tron::tron(parent.env(environment()))
   }
}
