#' Log Message to Output File
#'
#' This function executes immediately before the function definitions for the
#' base handler functions (\code{\link[base]{message}},
#' \code{\link[base]{warning}}, and
#' \code{\link[base]{stop}}/\code{\link[base]{stopifnot}}), and logs their
#' timestamped output (a bit more verbosely) to a log file. The log file
#' defaults to a \href{https://www.json.org/}{JSON} file, which is a portable
#' file format that is easily parsed by many systems, but will eventually have a
#' \code{.txt} option as well.
#'
#' While this function has an intended use of logging handler messages without
#' any direct user interaction, it is flexible enough to be used as you see fit.
#'
#' @param log_lvl Level of log output. In actual practice, one of "INFO",
#'   "WARN", and "STOP" ("ERROR") are common.
#' @param log_msg Main log message.
#' @param log_detail Additional detail recored along with a log message.
#'
#' @export
loggit <- function(log_lvl, log_msg, log_detail = "") {
  
  timestamp <- format(Sys.time(), format = .config$ts_format)
  
  if (!file.exists(.config$logfile)) {
    logs_json <- rbind(data.frame(timestamp = timestamp,
                                  log_lvl = "INFO",
                                  log_msg = "Initial log",
                                  log_detail = "",
                                  stringsAsFactors = FALSE),
                       data.frame(timestamp = timestamp,
                                  log_lvl = log_lvl,
                                  log_msg = log_msg,
                                  log_detail = log_detail,
                                  stringsAsFactors = FALSE))
    jsonlite::write_json(logs_json, path = .config$logfile, pretty = TRUE)
  } else {
    logs_json <- jsonlite::read_json(.config$logfile, simplifyVector = TRUE)
    logs_json <- rbind(logs_json,
                       data.frame(timestamp = timestamp,
                                  log_lvl = log_lvl,
                                  log_msg = log_msg,
                                  log_detail = log_detail,
                                  stringsAsFactors = FALSE))
    jsonlite::write_json(logs_json, path = .config$logfile, pretty = TRUE)
  }
  
  invisible()
  
}
