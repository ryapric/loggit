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



#' Log It All!
#'
#' This function creates backups of loaded R package \code{NAMESPACE} files, and
#' adds the `loggit` package as an additional import to the package. On R
#' termination, the backups are restored. This allows `loggit` to mask the base
#' R condition handlers in all package functions, and not just those that you
#' define or call.
#'
#' Note: I don't know if the original \code{NAMESPACE} files will be restored if
#' R crashes before this finishes executing. Use at your own risk of
#' reinstalling your packages!
#'
#' @param pkgs Character vector of package names, or something that can be
#'   coerced to a character vector.
loggitall <- function(pkgs) {
  
  pkgs <- unlist(pkgs)
  
  for (pkg in pkgs) {
    ns_file <- paste0(find.package(pkg), "/NAMESPACE")
    ns_bak <- paste0(ns_file, ".bak")
    file.copy(from = ns_file, to = ns_bak)
    cat("import(loggit)", file = ns_file, append = TRUE)
  }
  
  cat(pkgs, file = .config$loggitall_file, sep = "\n", append = TRUE)
  
  invisible()
  
}



#' Stop It All!
#' 
#' Revert the functionality of \code{\link{loggitall}}.
stoppitall <- function() {
  
  pkgs <- readLines(.config$loggitall_file)
  
  for (pkg in pkgs) {
    ns_file <- paste0(find.package(pkg), "/NAMESPACE")
    ns_bak <- paste0(ns_file, ".bak")
    file.remove(ns_file)
    file.rename(from = ns_bak, to = ns_file)
  }
  
  file.remove(.config$loggitall_file)
  
  invisible()
  
}



# I Think I Broke My NAMESPACEs!
#
# If folder has ns_file and ns_bak, fix it.
NULL
