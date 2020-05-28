## chshli: Check Shared Libraries

### What Is This For?

#### Use Case 1: Distribution Upgrade

Say you just upgraded from Ubuntu 19.10 to Ubuntu 20.04, as I just did. You may have a number of
CRAN packages installed from source in `/usr/local/lib/R/site-library`.  All fine.

But `apt` and `dpkg` do not know about them. So it may remove libraries _not knowing about these implicit
dependencies_.  Next time you try to load one of the affected packages, it will fail. 

*Example:*

```r
R> library(chshli)
Attaching chshli on ubuntu:20.04
R> checkSharedLibs(db="19.10")
Looking at libxml2.so.2 :       libxml2 
Looking at libapt-pkg.so.5.90 : libapt-pkg5.90 
Looking at libgit2.so.27 :      libgit2-27 
NULL
R>
```

This identifies `libgit2` (likely via package [git2r](https://cran.r-project.org/package=git2r)), 
`libapt-pkg`  (likely via [RcppApt](https://cran.r-project.org/package=RcppAPT) and 
`libxml2` (likely via [xml2](https://cran.r-project.org/package=xml2)). All three can probably
be fixed via a simple reinstallation from source.


#### Use Case 2: RSPM Installations

Say you experiment with RSPM, for example via 
[this Rocker container](https://github.com/rocker-org/rocker/tree/master/r-rspm/bionic) which you can
pull via `docker pull rocker/r-rspm:18.04`.  And you did `install.packages("xml2")`. Now you can do
(after installing this package, of course)

*Example:*

```r
R> library(chshli)
Attaching chshli on ubuntu:18.04
R> checkSharedLibs()
Looking at libxml2.so.2 :       libxml2 
NULL
> 
```

and installing (at the system-level, _i.e._ as `root`) `sudo apt install libxml2` will make your package work.
Which is a very nice complement to the nice and fast installation via RSPM.


### Installation

For now from GitHub via `remotes::install_github("eddelbuettel/chshli")` or, if you have
[littler](https://github.com/eddelbuettel/littler), via `installGithub eddelbuettel/chshli`.

### Who

Dirk Eddelbuettel 

### License
                                                                                                
GPL (>= 2) 
