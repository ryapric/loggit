.onLoad <- function(libname, pkgname) {
  set_logfile(confirm = FALSE)
  set_timestamp_format(confirm = FALSE)
}

.onAttach <- function(libname, pkgname) {
  pkgversion <- read.dcf(system.file("DESCRIPTION", package = pkgname),
                         fields = "Version")
  msg <- paste0("Package ", pkgname, " version ", pkgversion, "\n",
                "NOTE: - Output file is set to", .config$logfile, ", unless set via `set_logfile()`.\n",
                "      - See `help(package = \"loggit\")` for help.")
  packageStartupMessage(msg)
}
