# Configuration Environment, to be used as needed.
.config <- new.env(parent = emptyenv())

# REMOVE ONCE UPDATE GOES THROUGH
.config$agreed_to_upcoming_loggit_updates <- FALSE
#' Agree to upcoming loggit changes
#'
#' This function takes no arguments, but must be run before calling `loggit()`
#' in a session. Due to the large, breaking changes coming in loggit v2.0, users
#' are required to acknowledge that they have seen the error message before
#' continuing to use this package's logging facilities.
#'
#' @export
agree_to_upcoming_loggit_updates <- function() {
  .config$agreed_to_upcoming_loggit_updates <- TRUE
}

#' Set Log File
#'
#' Set the log file that loggit will write to. No logs will be written until
#' this is set, as per CRAN policy. The suggested use of this function would be
#' to call it early, to log to the current working directory, as follows:
#' `set_logfile(paste0(getwd(), "/loggit.json"))`. If you are using `loggit` in
#' your package, you can wrap this function in `.onLoad()` so that the logfile
#' is set when your package loads.
#'
#' @param logfile Full path to log file. Until other output formats are
#'   introduced, the file name must end in ".json".
#' @param confirm Print confirmation of log file setting? Defaults to `TRUE`.
#'
#' @examples set_logfile(file.path(tempdir(), "loggit.json"))
#'
#' @export
set_logfile <- function(logfile = NULL, confirm = TRUE) {
  if (is.null(logfile)) {
    .config$logfile <- file.path(tempdir(), "loggit.json")
  } else {
    if (substr(logfile, nchar(logfile) - 4, nchar(logfile)) != ".json") {
      base::stop("Log file path must be explicitly JSON, i.e. end in '.json'")
    }
    .config$logfile <- logfile
    .config$templogfile <- FALSE
    if (confirm) print(paste0("Log file set to ", logfile))
  }
}


#' Get Log File
#'
#' Return the log file that loggit will write to.
#' 
#' @examples get_logfile()
#'
#' @export
get_logfile <- function() {
  .config$logfile
}


#' Set Timestamp Format
#'
#' Set timestamp format for use in output logs.
#'
#' @param ts_format ISO date format.
#' @param confirm Print confirmation of timestamp format setting? Defaults to
#'   `TRUE`.
#'   
#' @examples set_timestamp_format("%Y-%m-%d %H:%M:%S")
#'
#' @export
set_timestamp_format <- function(ts_format = "%Y-%m-%d %H:%M:%S", confirm = TRUE) {
  .config$ts_format <- ts_format
  if (confirm) print(paste0("Timestamp format set to ", ts_format))
}


#' Get Timestamp Format
#' 
#' Get timestamp format for use in output logs.
#' 
#' @examples get_timestamp_format()
#'
#' @export
get_timestamp_format <- function() {
  .config$ts_format
}


# Functions to be deprecated in next version
setLogFile <- function()
getLogFile
setTimestampFormat
getTimestampFormat