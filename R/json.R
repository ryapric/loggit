#' Title
#'
#' @param logdata 
#'
#' @return
#' @export
#'
#' @examples
write_ndjson <- function(logdata) {
  
}

#' Title
#'
#' @param logfile 
#'
#' @return
#' @export
#'
#' @examples
read_ndjson <- function(logfile) {
  logtxt <- readLines(logfile)
  logtxt
}
