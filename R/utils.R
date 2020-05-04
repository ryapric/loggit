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


#' Return log file as an R data frame
#'
#' This function returns a `data.frame` containing all the logs in the provided
#' `ndjson`` log file. If no explicit log file is provided, calling this
#' function will return a data frame of the log file currently pointed to by the
#' `loggit` functions.
#'
#' @param logfile Path to log file. Will default to currently-set log file.
#' @param log_format Format of log file. Defaults to "ndjson". Note that this
#'   may never have another option in the future, but the code is written to
#'   support it dynamically in the future, mostly as a placeholder to the
#'   author.
#'
#' @return A `data.frame`.
#'
#' @examples
#'   set_logfile(file.path(tempdir(), "loggit.json"), confirm = FALSE)
#'   message("Test log message")
#'   read_logs()
#'
#' @export
read_logs <- function(logfile, log_format = "ndjson") {
  if (missing(logfile)) logfile <- get_logfile()
  if (!file.exists(logfile)) {
    base::stop("Log file does not exist")
  }
  
  # This function may or may not take other log formats in the future, but I'm
  # making it dynamic for now anyway.
  
  # Dynamically choose reader function based on input format
  eval(str2expression(sprintf("read_%s(logfile)", log_format)))
}


#' Rotate log file
#' 
#' Truncates the log file to the line count provided as `rotate_lines`. 
#' 
#' `loggit`` makes no assumptions nor enforcement of calling this function; that
#' is to say, the onus of log rotation is up to the developer. You 
#'
#' @param rotate_lines The number of log entries to keep in the logfile.
#'   Defaults to 100,000.
#' @param logfile Log file to truncate. Defaults to the currently-configured log
#'   file.
#'
#' @examples
#'   # Truncate "default" log file to 100 lines
#'   set_logfile()
#'   for (i in 1:150) {loggit("INFO", i, echo = FALSE)}
#'   rotate_logs(100)
#'   
#'   # Truncate a different log file to 250 lines
#'   another_log <- file.path(tempdir(), "another.log")
#'   set_logfile(another_log)
#'   for (i in 1:300) {loggit("INFO", i, echo = FALSE)}
#'   set_logfile() # clears pointer to other log file
#'   rotate_logs(250, another_log)
#'
#' @export
rotate_logs <- function(rotate_lines = 100000, logfile) {
  if (missing(logfile)) logfile <- get_logfile()
  log_df <- read_logs(logfile)
  log_df <- log_df[(nrow(log_df) - rotate_lines + 1):nrow(log_df), ]
  write_ndjson(log_df, logfile, echo = FALSE, overwrite = TRUE)
}
