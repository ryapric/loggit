# Configuration Environment, to be used as needed.
.config <- new.env(parent = emptyenv())


#' Set Log File
#'
#' Set the log file that loggit will write to. No logs outside of a temporary
#' directory will be written until this is set explicitly, as per CRAN policy.
#' Therefore, the default behavior is to create a file named `loggit.log` in
#' your system's temporary directory.
#'
#' A suggested use of this function would be to call it early, to log to the
#' current working directory, as follows: `set_logfile(paste0(getwd(),
#' "/loggit.log"))`. If you are using `loggit` in your package, you can wrap
#' this function in `.onLoad()` so that the logfile is set when your package
#' loads.
#'
#' @param logfile Full or relative path to log file. If not provided, will write
#'   to `<tmpdir>/loggit.log`.
#' @param confirm Print confirmation of log file setting? Defaults to `TRUE`.
#'
#' @examples set_logfile(file.path(tempdir(), "loggit.log"))
#'
#' @export
set_logfile <- function(logfile = NULL, confirm = TRUE) {
  if (is.null(logfile)) {
    .config$logfile <- file.path(tempdir(), "loggit.log")
  } else {
    .config$logfile <- logfile
  }
  if (confirm) print(paste0("Log file set to ", logfile))
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
#' Set timestamp format for use in output logs. This function performs no time
#' format validations, but will echo out the current time in the provided format
#' for manual validation.
#'
#' This function provides no means of setting a timezone, and instead relies on
#' the host system's time configuration to provide this. This is to enforce
#' consistency across software running on the host.
#'
#' @param ts_format ISO date format. Defaults to ISO-8601 (e.g.
#'   "2020-01-01T00:00:00+0000").
#' @param confirm Print confirmation message of timestamp format? Defaults to
#'   `TRUE`.
#'
#' @examples set_timestamp_format("%Y-%m-%d %H:%M:%S")
#'
#' @export
set_timestamp_format <- function(ts_format = "%Y-%m-%dT%H:%M:%S%z", confirm = TRUE) {
  .config$ts_format <- ts_format
  if (confirm) {
    print(paste0("Timestamp format set to ", ts_format))
    print(paste0("Current time in this format: ", format(Sys.time(), format = ts_format)))
  }
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
