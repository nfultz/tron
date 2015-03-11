# tron: Pain Free Logging 

This package provides the `tron` function, which decorates all functions in a session or package to let you follow along with the execution.

Here is an example:

    autolg> f <- function(a,b) a / b
    
    autolg> zzz <- function(x,y) f(x,y) / f(y,x)
    
    autolg> tron(environment(), verbose=TRUE)
    wrapping  f
    wrapping	zzz
    
    autolg> zzz(2,1)
    2015-02-24 18:55:10	zzz(2, 1) begin
    2015-02-24 18:55:10		f(x, y) begin
    2015-02-24 18:55:10		f(x, y) end
    2015-02-24 18:55:10		f(y, x) begin
    2015-02-24 18:55:10		f(y, x) end
    2015-02-24 18:55:10	zzz(2, 1) end
    
## Logging a package

If you would like to add logging to an entire package, add the following to `R/zzz.R`:

    if(getOption("tron", FALSE) && require(tron)) tron(environment())

This will be run on package load and add logging to every function in the package, including 
non-exported functions. To activate it, 

    options(tron=TRUE) # Set *before* you load the pkg
    library(mypkg)
