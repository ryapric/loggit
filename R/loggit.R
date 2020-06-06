#' Log entries to file
#'
#' This function executes immediately before the function definitions for the
#' base handler functions ([message][base::message], [warning][base::warning],
#' and [stop][base::stop], and logs their timestamped output (a bit more
#' verbosely) to a log file. The log file is an
#' [ndjson](https://github.com/ndjson) file, which is a portable, JSON-based
#' format that is easily parsed by many line-processing systems.
#'
#' @param log_lvl Level of log output. In actual practice, one of "DEBUG",
#'   "INFO", "WARN", and "ERROR" are common, but any string may be supplied if
#'   `custom_log_lvl` is TRUE. Will be coerced to class `character`.
#' @param log_msg Main log message. Will be coerced to class `character`.
#' @param ... A named `list` or named `vector` (each element of length one) of
#'   other custom fields you wish to log. You do not need to explicitly provide
#'   these fields as a formal list or vector, as shown in the example; R handles
#'   the coercion.
#' @param echo Should the log file entry be printed to the console as well?
#'   Defaults to `TRUE`, and will print out the `ndjson` line to be logged. This
#'   argument is passed as `FALSE` when called from `loggit`'s handlers, since
#'   they still call base R's handlers at the end of execution, all of which
#'   print to the console as well.
#' @param custom_log_lvl Allow log levels other than "DEBUG", "INFO", "WARN",
#'   and "ERROR"? Defaults to `FALSE`, to prevent possible typos by the
#'   developer, and to limit the variation in structured log contents. Overall,
#'   setting this to `TRUE`` is not recommended, but is an option for
#'   consistency with other frameworks the user may work with.
#' @param sanitizer Sanitizer function to run over elements in log data. The
#'   default sanitizer, if not specified, is [default_ndjson_sanitizer()]. See
#'   the [sanitizers] documentation for information on how to write your own
#'   (un)sanitizer functions.
#'
#' @examples
#'   loggit("INFO", "This is a message", but_maybe = "you want more fields?",
#'   sure = "why not?", like = 2, or = 10, what = "ever")
#'
#' @export
loggit <- function(log_lvl, log_msg, ..., echo = TRUE, custom_log_lvl = FALSE, sanitizer) {
  # Try to suggest limited log levels to prevent typos by users
  log_lvls <- c("DEBUG", "INFO", "WARN", "ERROR")
  if (!(log_lvl %in% log_lvls) && !custom_log_lvl) {
    base::stop(paste0("Nonstandard log_lvl ('", log_lvl, "').\n",
                      "Should be one of DEBUG, INFO, WARN, or ERROR. Please check if you made a typo.\n",
                      "If you insist on passing a custom level, please set 'custom_log_lvl = TRUE' in the call to 'loggit()'."
    ))
  }
  
  timestamp <- format(Sys.time(), format = .config$ts_format)
  
  dots <- list(...)
  
  if (length(dots) > 0) {
    if (any(unlist(lapply(dots, length)) > 1)) {
      base::warning("Each custom log field should be of length one, or else your logs will be multiplied!")
    }
    log_df <- data.frame(
      timestamp = timestamp,
      log_lvl = as.character(log_lvl),
      log_msg = as.character(log_msg),
      dots,
      stringsAsFactors = FALSE
    )
  } else {
    log_df <- data.frame(
      timestamp = timestamp,
      log_lvl = as.character(log_lvl),
      log_msg = as.character(log_msg),
      stringsAsFactors = FALSE
    )
  }
  
  # Sanitize
  if (missing(sanitizer)) {
    sanitize <- default_ndjson_sanitizer
  } else {
    sanitize <- sanitizer
  }
  
  for (field in colnames(log_df)) {
    log_df[, field] <- sanitize(log_df[, field])
  }
  
  write_ndjson(log_df, echo = echo)
}
