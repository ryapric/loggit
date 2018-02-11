#' Diagnostic Messages, and Output to Log
#'
#' Identical to base R's \code{\link[base]{message}}, but with included message
#' logging.
#' 
#' @param ... Same as base.
#' @param domain Same as base.
#' @param appendLF Same as base.
#'
#' @export
message <- function(..., domain = NULL, appendLF = TRUE) {
  args <- list(...)
  loggit(log_lvl = "INFO", log_msg = args[[1]])
  base::message(unlist(args), domain = domain, appendLF = appendLF)
}



#' Warning Messages, and Output to Log
#'
#' Identical to base R's \code{\link[base]{warning}}, but with included message
#' logging.
#' 
#' @param ... Same as base.
#' @param call. Same as base.
#' @param immediate. Same as base.
#' @param noBreaks. Same as base.
#' @param domain Same as base.
#' 
#' @export
warning <- function(..., call. = TRUE, immediate. = FALSE, noBreaks. = FALSE, 
                    domain = NULL) {
  args <- list(...)
  loggit(log_lvl = "WARN", log_msg = args[[1]])
  base::warning(unlist(args), call. = call., immediate. = immediate.,
                noBreaks. = noBreaks., domain = domain)
}



#' Stop Function Execution, and Output to Log
#'
#' Identical to base R's \code{\link[base]{stop}}, but with included message
#' logging. Also includes an added argument for control over additional log
#' detail in log output.
#'
#' @param ... Same as base.
#' @param call. Same as base.
#' @param domain Same as base.
#' @param log_detail Additional information to accompany log message. Must be a
#'   string.
#'
#' @export
stop <- function(..., call. = TRUE, domain = NULL, log_detail = "") {
  args <- list(...)
  base::stopifnot(is.character(log_detail))
  loggit(log_lvl = "STOP", log_msg = args[[1]], log_detail = log_detail)
  base::stop(unlist(args), call. = call., domain = domain)
}



#' Ensure the Truth of R Expressions, and Output to Log
#'
#' Identical to base R's \code{\link[base]{stopifnot}}, but with included
#' message logging. Also includes an added argument for control over additional
#' log detail in log output.
#'
#' @param ... Same as base.
#' @param log_detail Additional information to accompany log message. Must be a
#'   string.
#' 
# @export
stopifnot <- function(..., log_detail = "") {
  args <- list(...)
  base::stopifnot(is.character(log_detail))
  loggit(log_lvl = "STOP", log_msg = args[[1]], log_detail = log_detail)
  base::stopifnot(unlist(args))
}
