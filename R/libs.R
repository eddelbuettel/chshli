.libs <- function() {
    if (!.pkgenv$goodsystem)
        return(invisible(NULL))

    if (Sys.which("ldd") == "")
        stop("No 'ldd'.", call.=FALSE)

    if (Sys.which("xargs") == "")
        stop("No 'xargs'.", call.=FALSE)

    ## we take find, grep, sed, ... as given

    .findLib <- function(path) {
        ##file <- system.file("libs", paste0(path, ".so"), package=path)
        ##return(if (nchar(file) > 0) file else NULL)
        readLines(pipe(sprintf("find %s -name \\*so -type f -size +1024c | xargs -r ldd | grep 'not found' | sed -e 's/ => not found//' -e's/\t//'", path)))
    }
    rl <- lapply(.libPaths(), .findLib)
    vec <- do.call(rbind, rl)
    unique(vec[order(vec)])
}

.getDB <- function(rel=c("18.04", "19.10"), arch="amd64") {
    rel <- match.arg(rel)
    db <- system.file("extdata", paste0("libContents-", arch, ".", rel, ".gz"), package="chshli")
    if (nchar(db) == 0)
        stop("No data for '", rel, "' on '", arch,
             "'. See the 'rawdata' and 'extdata' directories in the sources.", call.=FALSE)
    dat <- read.table(db, row.names=1, col.names=c("path", "pkg"))
    dat
}

##' Check shared libraries on current system
##'
##' This function examine the shared libraries in argument
##' \code{vec}. It runs \code{ldd} on these, filters for \dQuote{not
##' found} to identify unresolved shared libraries and tries to map
##' these against (stored) information on distribution packages (where
##' Ubuntu 18.04 and 19.10 are currently supported).
##'
##' The internal helper function \code{.libs()} can be used to
##' identify shared libraries from packages in the current
##' \code{.libPaths()}.  Because search all packages in each 
##' \code{.libPaths()} entry at once (using shell tools) it does
##' not currently associate finds with the packages they originate
##' from.
##'
##' @title Check Shared Libraries
##' @param vec A (optional) character vector of shared libraries,
##'     typcially with major soname. If missing a default vector is
##'     used as fallback.
##' @param db An optional identifier for a library package database,
##'     should be one of "18.04" or "19.10".
##' @return Nothing currently but information is printed.
##' @author Dirk Eddelbuettel
##' @examples 
##' checkSharedLibs(c("libxml2.so.2"))
checkSharedLibs <- function(vec, db) {
    if (missing(vec)) {
        ## mostly for debugging / dev, to be removed eventually
        ##vec <- c("libxml2.so.2", "libapt-pkg.so.5.90", "libgit2.so.27", "libqdb_api.so")
        message("Setting default 'vec' argument based on .libPaths() scan.")
        vec <- .libs()
    }

    if (missing(db))
        db <- .getDB()
    else
        db <- .getDB(db)

    for (v in vec) {
        cat("Looking at", v, ":\t")
        ind <- grep(paste0("/", v), rownames(db))
        if (length(ind) > 0)
            cat(gsub(".*/", "", unique(db[ind, "pkg"])), "\n")
        else
            cat("<NA>\n")
    }
    invisible()
}
