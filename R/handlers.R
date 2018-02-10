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
  cond <- if (length(args) == 1L && inherits(args[[1L]], "condition")) {
    if (nargs() > 1L) 
      base::warning("additional arguments ignored in message()")
    args[[1L]]
  }
  else {
    msg <- .makeMessage(..., domain = domain, appendLF = appendLF)
    call <- sys.call()
    # Insert logger here =======================================================
    loggit(log_lvl = "INFO", log_msg = gsub("\n", "", msg))
    # ==========================================================================
    simpleMessage(msg, call)
  }
  defaultHandler <- function(c) {
    cat(conditionMessage(c), file = stderr(), sep = "")
  }
  withRestarts({
    signalCondition(cond)
    defaultHandler(cond)
  }, muffleMessage = function() NULL)
  invisible()
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
  if (length(args) == 1L && inherits(args[[1L]], "condition")) {
    cond <- args[[1L]]
    if (nargs() > 1L) 
      cat(gettext("additional arguments ignored in warning()"), 
          "\n", sep = "", file = stderr())
    msg <- conditionMessage(cond)
    call <- conditionCall(cond)
    # Insert logger here =======================================================
    loggit(log_lvl = "WARN", log_msg = gsub("\n", "", msg))
    # ==========================================================================
    withRestarts({
      .Internal(.signalCondition(cond, msg, call))
      .Internal(.dfltWarn(msg, call))
    }, muffleWarning = function() NULL)
    invisible(msg)
  } else {
    msg <- .makeMessage(..., domain = domain)
    # Insert logger here =======================================================
    loggit(log_lvl = "WARN", log_msg = gsub("\n", "", msg))
    # ==========================================================================
    .Internal(warning(call., immediate., noBreaks., msg))
  }
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
  stopifnot(is.character(log_detail))
  if (length(args) == 1L && inherits(args[[1L]], "condition")) {
    cond <- args[[1L]]
    if (nargs() > 1L) 
      warning("additional arguments ignored in stop()")
    msg <- conditionMessage(cond)
    call <- conditionCall(cond)
    # Insert logger here =======================================================
    loggit(log_lvl = "STOP", log_msg = gsub("\n", "", msg), log_detail = log_detail)
    # ==========================================================================
    .Internal(.signalCondition(cond, msg, call))
    .Internal(.dfltStop(msg, call))
  }
  else {
    msg <- .makeMessage(..., domain = domain)
    # Insert logger here =======================================================
    loggit(log_lvl = "STOP", log_msg = gsub("\n", "", msg), log_detail = log_detail)
    # ==========================================================================
    .Internal(stop(call., msg))
  }
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
  n <- length(ll <- list(...))
  if (n == 0L) 
    return(invisible())
  Dparse <- function(call, cutoff = 60L) {
    ch <- deparse(call, width.cutoff = cutoff)
    if (length(ch) > 1L) 
      paste(ch[1L], "....")
    else ch
  }
  head <- function(x, n = 6L) x[seq_len(if (n < 0L) max(length(x) + 
                                                          n, 0L) else min(n, length(x)))]
  abbrev <- function(ae, n = 3L) paste(c(head(ae, n), if (length(ae) > 
                                                          n) "...."), collapse = "\n  ")
  mc <- match.call()
  for (i in 1L:n) if (!(is.logical(r <- ll[[i]]) && !anyNA(r) && 
                        all(r))) {
    cl.i <- mc[[i + 1L]]
    msg <- if (is.call(cl.i) && identical(cl.i[[1]], quote(all.equal)) && 
               (is.null(ni <- names(cl.i)) || length(cl.i) == 3L || 
                length(cl.i <- cl.i[!nzchar(ni)]) == 3L)) 
      sprintf(gettext("%s and %s are not equal:\n  %s"), 
              Dparse(cl.i[[2]]), Dparse(cl.i[[3]]), abbrev(r))
    else sprintf(ngettext(length(r), "%s is not TRUE", "%s are not all TRUE"), 
                 Dparse(cl.i))
    stop(msg, call. = FALSE, domain = NA)
  }
  invisible()
}
