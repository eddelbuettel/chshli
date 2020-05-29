## chshli: Check Shared Libraries

### What Is This For?

Package management is a wonderful tool. If integrated with the operating system, it allows
us to install and upgrade components with great ease and reliability.  It is also pleasant
at the application level: CRAN functions really well thanks to `install.packages()` and
`update.packages()` even though these are generally unaware of the host OS (which can lead
to occassional frustrations).  The fact that the _OS_ package management system and the
_application_ package management system do not know about each other can lead to
occassional frictions.

There are two specific issues this package tries to help with.  We discuss both below.

#### Use Case 1: Distribution Upgrade

Say you just upgraded from Ubuntu 19.10 to Ubuntu 20.04, as I just did this week (in late
May of 2020).  You may have a number of CRAN packages installed from source in
`/usr/local/lib/R/site-library`.  All fine.

But `apt` and `dpkg` do not know about them. So it may remove libraries _not knowing about
these implicit dependencies_.  Next time you try to load one of the affected packages, it
will fail.

*Problem Illustration*

```r
R> library(git2r)
Error: package or namespace load failed for ‘git2r’ in dyn.load(file, DLLpath = DLLpath, ...):
 unable to load shared object '/usr/local/lib/R/site-library/git2r/libs/git2r.so':
  libgit2.so.27: cannot open shared object file: No such file or directory
R> 
```

The `chshli` package can help here:

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
`libxml2` (likely via [xml2](https://cran.r-project.org/package=xml2)). All three R packages 
can probably be fixed via a simple reinstallation from source.


#### Use Case 2: RSPM Installations

Say you experiment with RSPM, for example via [this Rocker
container](https://github.com/rocker-org/rocker/tree/master/r-rspm/bionic) which you can
pull via `docker pull rocker/r-rspm:18.04`.  And you did just run
`install.packages("xml2")`.  But maybe you cannot load it as the next example shows.

*Problem Illustration*

```r
> install.packages("xml2")
Installing package into ‘/usr/local/lib/R/site-library’
(as ‘lib’ is unspecified)
trying URL 'https://packagemanager.rstudio.com/all/__linux__/bionic/latest/src/contrib/xml2_1.3.2.tar.gz'
Content type 'binary/octet-stream' length 519621 bytes (507 KB)
==================================================
downloaded 507 KB

* installing *binary* package ‘xml2’ ...
* DONE (xml2)

The downloaded source packages are in
        ‘/tmp/RtmpW0G7Mr/downloaded_packages’
> library(xml2)
Error: package or namespace load failed for ‘xml2’ in dyn.load(file, DLLpath = DLLpath, ...):
 unable to load shared object '/usr/local/lib/R/site-library/xml2/libs/xml2.so':
  libxml2.so.2: cannot open shared object file: No such file or directory
> 
```

Here RSPM helps us with a quick and painless download of a binary. Which we then cannot load 
as it depends on an _OS-level_ package.  

The `chshli` package can help here:


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

### Author

Dirk Eddelbuettel 

### License
                                                                                                
GPL (>= 2) 
