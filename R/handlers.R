#' loggit's Exception Handlers
#'
#' These exception handlers are identical to base R's [message][base::message],
#' [warning][base::warning], and [stop][base::stop], but with included logging
#' of the exception messages.
#'
#' @param .loggit Should loggit function execute? Defaults to \code{TRUE}.
#' @param log_detail Additional information to accompany log message. Must be a
#'   string.
#' @param echo Should loggit's log be echoed to the console, as well? Defaults
#'   to \code{FALSE}.
#'
#' @name handlers
NULL



#' @rdname handlers
#' 
#' @inheritParams base::message
#' 
#' @examples
#' agree_to_upcoming_loggit_updates()
#' if (2 < 1) message("Don't say such silly things!")
#'
#' @export
message <- function(..., domain = NULL, appendLF = TRUE, .loggit = TRUE,
                    log_detail = "", echo = FALSE) {
  args <- list(...)
  if(.loggit) loggit(log_lvl = "INFO", log_msg = args[[1]], log_detail,
                     echo = echo)
  base::message(unlist(args), domain = domain, appendLF = appendLF)
}



#' @rdname handlers
#'
#' @inheritParams base::warning
#' 
#' @examples
#' agree_to_upcoming_loggit_updates()
#' if (2 < 1) warning("You may want to review that math, and so this is your warning")
#' 
#' @export
warning <- function(..., call. = TRUE, immediate. = FALSE, noBreaks. = FALSE, 
                    domain = NULL, .loggit = TRUE, log_detail = "",
                    echo = FALSE) {
  args <- list(...)
  if (.loggit) loggit(log_lvl = "WARN", log_msg = args[[1]],
                      log_detail = log_detail, echo = echo)
  base::warning(unlist(args), call. = call., immediate. = immediate.,
                noBreaks. = noBreaks., domain = domain)
}



#' @rdname handlers
#' 
#' @inheritParams base::stop
#' 
#' @examples
#' agree_to_upcoming_loggit_updates()
#' if (2 < 1) stop("This is a completely false condition, which throws an error")
#' 
#' @export
stop <- function(..., call. = TRUE, domain = NULL, .loggit = TRUE,
                 log_detail = "", echo = FALSE) {
  args <- list(...)
  base::stopifnot(is.character(log_detail))
  if (.loggit) loggit(log_lvl = "ERROR", log_msg = args[[1]],
                      log_detail = log_detail, echo = echo)
  base::stop(unlist(args), call. = call., domain = domain)
}
