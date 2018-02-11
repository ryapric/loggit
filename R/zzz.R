.onLoad <- function(libname, pkgname) {
  setTimestampFormat()
  setLogFile()
}

.onAttach <- function(libname, pkgname) {
  pkgversion <- read.dcf(system.file("DESCRIPTION", package = pkgname),
                         fields = "Version")
  msg <- paste("Package", pkgname, "version", pkgversion, "\n",
               "NOTE: - Output file is set to", .config$logfile,  "\n",
               "      - See 'package?loggit' for help.")
  packageStartupMessage(msg)
}
