
# This will activate tron on a whole package
.onLoad <- function(libName,pkgName) {
   if(getOption("tron", FALSE) && requireNamespace("tron", quietly=TRUE)) {
     message("Using tron on ", pkgName)
     tron:::tron.environment(parent.env(environment()))
   }
}
