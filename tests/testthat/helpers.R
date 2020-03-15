# Each test context needs to wipe the log file etc., so define cleanup()
# function here
cleanup <- function() {
  file.remove(.config$logfile)
}
