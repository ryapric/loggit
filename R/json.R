#' Default sanitization for ndJSON.
#'
#' This is the default ndJSON sanitizer function for log data being read into
#' the R session by [read_logs()]. This type of function is needed because since
#' `loggit` reimplements its own string-based JSON parser, and not a fancy one
#' built from an AST or something, it's very easy to have bad patterns break
#' your logs. You may also specify your own sanitizer function to pass to
#' [loggit()], which takes a single string and returns an
#' (optionally-transformed) string, where each string is an individual element
#' of the log data.
#' 
#' The default string patterns and their replacements are currently mapped as
#' follows:
#' 
#'  | Character | Replacement in log file |
#'  |:--------- | :---------------------- |
#'  | `{`       | `__LEFTBRACE__`         |
#'  | `}`       | `__RIGHTBRACE__`        |
#'  | `"`       | `__DBLQUOTE__`          |
#'  | `,`       | `__COMMA__`             |
#'  | `\r`      | `__CR__`                |
#'  | `\n`      | `__LF__`                |
#'
#' @param string Each element of the log data to operate on. Note that this is
#'   *each element*, not each line in the logs. For example, each entry in the
#'   `log_msg` field across all logs will be sanitized/unsanitized individually.
#'   This is important because if writing your own sanitizer function, it must
#'   ***take and return a single string*** as its argument.
#' @param sanitize Whether the operation will sanitize, or unsanitize the log
#'   data. Defaults to `TRUE`, for sanitization on write.
#' 
#' @return A single string.
#'
#' @name sanitizers
default_ndjson_sanitizer <- function(string, sanitize = TRUE) {
  # String map; will dispatch left-vs.-right replacement based on `sanitize` bool
  map <- list(
    "\\{" = "__LEFTBRACE__",
    "\\}" = "__RIGHTBRACE__",
    '"' = "__DBLQUOTE__",
    "," = "__COMMA__",
    "\r" = "__CR__",
    "\n" = "__LF__"
  )
  
  for (k in names(map)) {
    if (sanitize) {
      string <- gsub(k, map[k], string)
    } else {
      string <- gsub(map[k], k, string)
    }
  }
  
  string
}

#' @rdname sanitizers
default_ndjson_unsanitizer <- function(string) {
  default_ndjson_sanitizer(string, sanitize = FALSE)
}


#' Write ndJSON-formatted log file
#'
#' @param log_df Data frame of log data. Rows are converted to `ndjson` entries,
#'   with the columns as the fields.
#' @param logfile Log file to write to. Defaults to currently-configured log
#'   file.
#' @param echo Echo the `ndjson` entry to the R console? Defaults to `TRUE`.
#' @param overwrite Overwrite previous log file data? Defaults to `FALSE`, and
#'   so will append new log entries to the log file.
write_ndjson <- function(log_df, logfile, echo = TRUE, overwrite = FALSE) {
  if (missing(logfile)) logfile <- get_logfile()
  
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
        # Throw warning if embedded newlines are detected
        if (grepl("\\n|\\r", log_df[row, col])) {
          base::warning(paste0("Logs in ndjson format should not have embedded newlines!\n",
                               "found here: ", log_df[row, col]))
        }
        logdata[row] <- paste0(logdata[row], sprintf('\"%s\": \"%s\", ', col, log_df[row, col]))
      }
    }
    # Drop the trailing comma and space from the last entry, and close the JSON
    logdata[row] <- substring(logdata[row], 1, nchar(logdata[row]) - 2)
    logdata[row] <- paste0(logdata[row], "}")
  }
  
  # Cat out if echo is on, and write to log file
  if (echo) cat(logdata, sep = "\n")
  write(logdata, file = logfile, append = !overwrite)
}

#' Read ndJSON-formatted log file
#'
#' @param logfile Log file to read from, and convert to a `data.frame`.
#' @param unsanitizer Unsanitizer function passed in from [read_logs()].
#'
#' @return A `data.frame`
read_ndjson <- function(logfile, unsanitizer) {
  # Set unsanitizer
  unsanitize <- unsanitizer

  # Read in lines of log data
  logdata <- readLines(logfile)
  
  # List first; easier to add to dynamically
  log_df <- list()
  
  # Split out the log data into individual pieces, which will include JSON keys
  # AND values
  log_kvs <- strsplit(logdata, '\\{|"|", |: |\\}')
  
  rowcount <- length(log_kvs)
  for (lognum in 1:rowcount) {
    rowdata <- log_kvs[[lognum]]
    # Filter out emtpy values from strsplit()
    rowdata <- rowdata[!(rowdata %in% c("", " "))]
    
    for (logfieldnum in 1:length(rowdata)) {
      # If odd, it's the key; if even, it's the value, where the preceding element
      # is the corresponding key.
      if (logfieldnum %% 2 == 0) {
        colname <- rowdata[logfieldnum - 1]
        # If the field doesn't exist, create it with the right length
        if (!(colname %in% names(log_df))) {
          log_df[[colname]] <- vector(mode = typeof(rowdata[logfieldnum]), length = rowcount)
        }
        # Unsanitize text, and store to df
        rowdata[logfieldnum] <- unsanitize(rowdata[logfieldnum])
        log_df[[colname]][lognum] <- rowdata[logfieldnum]
      }
    }
  }
  
  log_df <- as.data.frame(log_df, stringsAsFactors = FALSE)
  log_df
}
