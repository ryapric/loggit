# Configuration Environment, to be used as needed.
.config <- new.env(parent = emptyenv())



#' Set Timestamp Format
#' 
#' Set timestamp format for use in output logs.
#' 
#' @param ts_format ISO date format.
#'
#' @export
setTimestampFormat <- function(ts_format = "%Y-%m-%d %H:%M:%S") {
  .config$ts_format <- ts_format
}



#' Set Log File
#'
#' Set the log file that loggit will write to. Defaults to one called
#' "loggit.json" in the working directory that exists on load.
#'
#' @param logfile Name of log file.
#' @param folder Folder in which the log file should exist.
#'
#' @export
setLogFile <- function(logfile = "loggit.json", folder = getwd()) {
  if (substr(folder, nchar(folder), nchar(folder)) == "/") {
    path_sep <- ""
  } else {
    path_sep <- "/"
  }
  .config$logfile <- paste0(folder, path_sep, logfile)
}
