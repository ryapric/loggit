.onLoad <- function(libname, pkgname) {
  setLogFile(confirm = FALSE)
  setTimestampFormat(confirm = FALSE)
  .config$templogfile <- TRUE
  .config$seenmessage <- FALSE
}

.onAttach <- function(libname, pkgname) {
  
  pkgversion <- read.dcf(system.file("DESCRIPTION", package = pkgname),
                         fields = "Version")
  msg <- paste("Package", pkgname, "version", pkgversion, "\n",
               "NOTE: - Output file is set to", .config$logfile,  "\n",
               "      - See 'help(package = \"loggit\")' for help.")
  packageStartupMessage(msg)
}
