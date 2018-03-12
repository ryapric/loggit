#' Log Message to Output File
#'
#' This function executes immediately before the function definitions for the
#' base handler functions ([message][base::message], [warning][base::warning],
#' and [stop][base::stop], and logs their timestamped output (a bit more
#' verbosely) to a log file. The log file defaults to a
#' [JSON](https://www.json.org/) file, which is a portable file format that is
#' easily parsed by many systems, but will eventually have a `.txt` option as
#' well.
#'
#' While this function has an intended use of logging handler messages without
#' any direct user interaction, it is flexible enough to be used as you see fit.
#'
#' @param log_lvl Level of log output. In actual practice, one of "INFO",
#'   "WARN", and "ERROR" are common, but any string may be supplied. Will be
#'   coerced to class `character`.
#' @param log_msg Main log message. Will be coerced to class `character`.
#' @param log_detail Additional detail recorded along with a log message.
#' @param ... A named `list` or named `vector` (each element of length one) of
#'   other custom fields you wish to log. You do not need to explicitly provide
#'   these fields as a formal list or vector, as shown in the example; R handles
#'   the coercion.
#' @param echo Should a message be printed to the console as well? Defaults to
#'   `TRUE`, and is truncated to just the level & message of the log. This
#'   argument is passed as `FALSE` when called from `loggit`'s handlers, since
#'   they still call base R's handlers at the end of execution, all of which
#'   print to the console as well.
#'
#' @examples
#'  loggit("INFO", "This is a message", but_maybe = "you want more fields?",
#'  sure = "why not?", like = 2, or = 10, what = "ever")
#'
#' @export
loggit <- function(log_lvl, log_msg, log_detail = "", ..., echo = TRUE) {
  
  if (.config$templogfile && !.config$seenmessage) {
    base::warning(paste0("loggit has no persistent log file. Please set with ",
                         "setLogFile(logfile), or see package?loggit for more help.\n ",
                         "Otherwise, you can recover your logs (from THIS R SESSION ONLY) ",
                         "via copying ", .config$logfile, " to a persistent folder."))
    if (log_detail == "") log_detail <- "User was warned about non-persistent log file."
    .config$seenmessage <- TRUE
  } else {
    .config$templogfile <- FALSE
  }
  
  timestamp <- format(Sys.time(), format = .config$ts_format)
  
  dots <- list(...)
  
  if (length(dots) > 0) {
    if (any(unlist(lapply(dots, length)) > 1))
      base::warning("Each custom log field should be of length one, or else your logs will be multiplied!")
    log_df <- data.frame(
      timestamp = timestamp,
      log_lvl = as.character(log_lvl),
      log_msg = as.character(log_msg),
      log_detail = log_detail,
      dots,
      stringsAsFactors = FALSE)
  } else {
    log_df <- data.frame(
      timestamp = timestamp,
      log_lvl = as.character(log_lvl),
      log_msg = as.character(log_msg),
      log_detail = log_detail,
      stringsAsFactors = FALSE)
  }
  
  if (!file.exists(.config$logfile) || length(readLines(.config$logfile)) == 0) {
    logs_json <- dplyr::bind_rows(
      data.frame(timestamp = timestamp,
                 log_lvl = "INFO",
                 log_msg = "Initial log",
                 log_detail = "",
                 stringsAsFactors = FALSE),
      log_df)
    jsonlite::write_json(logs_json, path = .config$logfile, pretty = TRUE)
  } else {
    logs_json <- jsonlite::read_json(.config$logfile, simplifyVector = TRUE)
    logs_json <- dplyr::bind_rows(logs_json, log_df)
    jsonlite::write_json(logs_json, path = .config$logfile, pretty = TRUE)
  }
  
  if (echo) base::message(paste(c(log_lvl, log_msg), collapse = ": "))
  
  invisible()
  
}



#' Return Log File as an R Object
#'
#' This function returns a `data.frame` (by default) containing all the logs in
#' the provided JSON log file. If no explicit log fie is provided, calling this
#' function will return a data frame of the log file currently pointed to by the
#' loggit functions. Users can request that the logs be returned as a `list`,
#' though this is not recommended.
#'
#' @param logfile JSON-format log file to return.
#' @param as_df Should logfile be returned in a `data.frame` vs. a `list`?
#'   Defaults to `TRUE`, and will return a `data.frame`.
#'
#' @return A `data.frame`.
#' 
#' @examples
#' setLogFile(file.path(tempdir(), "loggit.json"), confirm = FALSE)
#' message("Test log message")
#' get_logs(getLogFile())
#'
#' @export
get_logs <- function(logfile, as_df = TRUE) {
  if (missing(logfile)) logfile <- .config$logfile
  if (!file.exists(logfile)) {
    base::stop("Log file does not exist")
  } else {
    jsonlite::read_json(logfile, simplifyVector = as_df)
  }
}
