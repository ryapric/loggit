#' Title
#'
#' @param log_df
#'
#' @return
#' @export
#'
# @examples
write_ndjson <- function(log_df, echo = TRUE) {
  # logdata will be built into a character vector where each element is a valid
  # JSON object, constructed from each row of the log data frame.
  logdata <- character(nrow(log_df))
  
  # The looping construct makes it easier to read & debug than an `lapply()` or
  # similar.
  for (row in 1:nrow(log_df)) {
    # Open the JSON
    logdata[row] <- paste0(logdata[row], "{")
    for (col in colnames(log_df)) {
      # Only log non-NA entries to JSON, in case there's more than one to flush
      # at once
      if (!is.na(log_df[row, col])) {
        logdata[row] <- paste0(logdata[row], sprintf('\"%s\": \"%s\", ', col, log_df[row, col]))
      }
    }
    # Drop the trailing comma and space from the last entry, and close the JSON
    logdata[row] <- substring(logdata[row], 1, nchar(logdata[row]) - 2)
    logdata[row] <- paste0(logdata[row], "}")
  }
  
  # Cat out if echo is on, and append to log file
  if (echo) cat(logdata, sep = "\n")
  write(logdata, file = .config$logfile, append = TRUE)
}

#' Read ndJSON-formatted log file
#'
#' @param logfile 
#'
#' @return
#' @export
#'
# @examples
read_ndjson <- function(logfile) {
  logtxt <- readLines(logfile)
  logdata <- logtxt
  logdata
}
