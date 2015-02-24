# Autologger: Pain Free Logging 

This package provides the `autolog` function, which instruments all functions in an environment to let you follow along with the execution.

Here is an example:

    autolg> f <- function(a,b) a / b
    
    autolg> zzz <- function(x,y) f(x,y) / f(y,x)
    
    autolg> autolog(environment(), verbose=TRUE)
    wrapping  f
    wrapping	zzz
    
    autolg> zzz(2,1)
    2015-02-24 18:55:10	zzz(2, 1) enter
    2015-02-24 18:55:10		f(x, y) enter
    2015-02-24 18:55:10		f(x, y) exit
    2015-02-24 18:55:10		f(y, x) enter
    2015-02-24 18:55:10		f(y, x) exit
    2015-02-24 18:55:10	zzz(2, 1) exit