# Configuration Environment, to be used as needed.
.config <- new.env(parent = emptyenv())



#' Set Timestamp Format
#'
#' Set timestamp format for use in output logs.
#'
#' @param ts_format ISO date format.
#' @param confirm Print confirmation of timestamp format setting? Defaults to
#'   `TRUE`.
#'
#' @export
setTimestampFormat <- function(ts_format = "%Y-%m-%d %H:%M:%S", confirm = TRUE) {
  .config$ts_format <- ts_format
  if (confirm) print(paste0("Timestamp format set to ", ts_format))
  invisible()
}

#' Get Timestamp Format
#' 
#' Get timestamp format for use in output logs.
#'
#' @export
getTimestampFormat <- function() {
  print(.config$ts_format)
  invisible()
}



#' Set Log File
#'
#' Set the log file that loggit will write to. Defaults to one called
#' "loggit.json" in the working directory that exists on load.
#'
#' @param logfile Full path to log file. Until other output formats are
#'   introduced, the file name must end in ".json".
#' @param confirm Print confirmation of log file setting? Defaults to `TRUE`.
#'
#' @export
setLogFile <- function(logfile = paste0(getwd(), "/", "loggit.json"),
                       confirm = TRUE) {
  
  if (substr(logfile, nchar(logfile) - 4, nchar(logfile)) != ".json")
    base::stop("Log file path must be explcitly JSON, i.e. end in '.json'")
  .config$logfile <- logfile
  if (confirm) print(paste0("Log file set to ", logfile))
  invisible()
  
}

#' Get Log File
#'
#' Get the log file that loggit will write to.
#'
#' @export
getLogFile <- function() {
  print(.config$logfile)
  invisible()
}
