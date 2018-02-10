.onLoad <- function(libname, pkgname) {
  setTimeStampFormat()
  setLogFile()
}

# .onAttach <- function(libname, pkgname) {
#   pkgversion <- read.dcf(system.file("DESCRIPTION", package = pkgname), 
#                          fields = "Version")
#   msg <- paste("Package", pkgname, "version", pkgversion, "\n",
#                "NOTE: - Logging level is set to", "", "\n",
#                "      - Output file is", "",  "\n",
#                "      - See 'package?loggit' for help.")
#   packageStartupMessage(msg)
# }
