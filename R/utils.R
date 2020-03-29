# Helper function to append rows 
bind_rows_loggit <- function(df1, df2) {
  stopifnot('data.frame' %in% class(df1))
  stopifnot('data.frame' %in% class(df2))
  
  headers1 <- colnames(df1)
  headers2 <- colnames(df2)
  headers <- union(headers1, headers2)
  
  for (header in headers) {
    if (!(header %in% headers1)) {
      df1[, header] <- NA
    }
    if (!(header %in% headers2)) {
      df2[, header] <- NA
    }
  }
  
  rbind(df1, df2)
}


#' Rotate log file
#'
#' @param rotate_lines 
#'
#' @return
#' @export
#'
#' @examples
rotate_logs <- function(rotate_lines = 100000) {
  log_df <- read_logs(.config$logfile)
  log_df <- log_df[(nrow(log_df) - rotate_lines + 1):nrow(log_df), ]
  write_ndjson(log_df, echo = FALSE, overwrite = TRUE)
}
