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

.getDB <- function(rel="18.04", arch="amd64") {
    db <- system.file("extdata", paste0("libContents-", arch, ".", rel, ".gz"), package="chshli")
    if (nchar(db) == 0)
        stop("No data for '", rel, "' on '", arch, "'", call.=FALSE)
    dat <- read.table(db, row.names=1, col.names=c("path", "pkg"))
    dat
}

checkSharedLibs <- function(vec, db) {
    if (missing(vec))
        vec <- c("libxml2.so.2", "libapt-pkg.so.5.90", "libgit2.so.27", "libqdb_api.so")
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
    NULL

}
