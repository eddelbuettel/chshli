
.pkgenv <- new.env(parent=emptyenv())

.onAttach <- function(libname, pkgname) {

    goodSystem <- Sys.info()[["sysname"]] == "Linux"

    if (goodSystem) 
        goodSystem <- file.exists("/etc/os-release")

    if (goodSystem) {
        osvertab <- read.table("/etc/os-release", sep="=", row.names=1, col.names=c("key","value"))
        osver <- osvertab[,"value"]
        names(osver) <- rownames(osvertab)
        sysid <- paste(osver["ID"], osver["VERSION_ID"], sep=":")
        .pkgenv[["sysid"]] <- sysid
    } else {
        .pkgenv[["sysid"]] <- "unknown"
    }

    if (goodSystem)
        packageStartupMessage("Attaching chshli on ", .pkgenv$sysid)
    else
        packageStartupMessage("Attaching chshli but no support")

    .pkgenv[["goodsystem"]] <- goodSystem
}
