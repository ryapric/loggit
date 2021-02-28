context("JSON functions")


# Testing both the ability to write to, and read from ndjson here, since it
# would be hard to test that the file is ndjson without reading it back in
# anyway
test_that("write_logs() and read_logs() work in tandem", {
  loggit("INFO", "msg1", echo = FALSE)
  loggit("INFO", "msg2", echo = FALSE)
  loggit("INFO", "msg3", echo = FALSE)
  loggit("INFO", "msg4", extra = "fields", echo = FALSE)
  
  log_df_want <- data.frame(
    timestamp = rep(format(Sys.time(), format = get_timestamp_format()), 4),
    log_lvl = rep("INFO", 4),
    log_msg = c("msg1", "msg2", "msg3", "msg4"),
    extra = c("", "", "", "fields"),
    stringsAsFactors = FALSE
  )
  
  log_df_got <- read_logs(get_logfile())
  
  # jk, set timestamps equal, since CRAN tests started failing because of
  # just-barely-different results
  log_df_want$timestamp <- log_df_got$timestamp
  
  expect_equal(log_df_want, log_df_got)
})
cleanup()

test_that("write_logs() and read_logs() work with disallowed JSON characters via santizers", {
  loggit("INFO", 'default { } , " \r \n sanitizer', echo = FALSE)
  
  comma_replacer <- function(string) {
    string <- gsub(",", " - ", string)
    string
  }
  loggit("INFO", "custom,sanitizer", echo = FALSE, sanitizer = comma_replacer)
  
  log_df_want <- data.frame(
    timestamp = rep(format(Sys.time(), format = get_timestamp_format()), 2),
    log_lvl = c("INFO", "INFO"),
    log_msg = c(
      "default __LEFTBRACE__ __RIGHTBRACE__ __COMMA__ __DBLQUOTE__ __CR__ __LF__ sanitizer",
      "custom - sanitizer"
    ),
    stringsAsFactors = FALSE
  )
  
  # Need to pass in a dummy unsanitizer, to return the sanitized strings as-is
  # for checking
  log_df_got <- read_logs(unsanitizer = function(x) {x})
  
  # jk, set timestamps equal, since CRAN tests started failing because of
  # just-barely-different results
  log_df_want$timestamp <- log_df_got$timestamp
  
  expect_equal(log_df_want, log_df_got)
})
cleanup()

test_that("read_logs() works with unsanitizers", {
  loggit("INFO", 'default { } , " \r \n unsanitizer', echo = FALSE)
  
  comma_replacer <- function(string) {
    string <- gsub(",", " - ", string)
    string
  }
  dash2comma_replacer <- function(string) {
    string <- gsub(" - ", ",", string)
    string
  }
  loggit("INFO", "custom,unsanitizer", echo = FALSE, sanitizer = comma_replacer)
  
  log_df_want <- data.frame(
    timestamp = rep(format(Sys.time(), format = get_timestamp_format()), 2),
    log_lvl = c("INFO", "INFO"),
    log_msg = c(
      'default { } , " \r \n unsanitizer',
      "custom,unsanitizer"
    ),
    stringsAsFactors = FALSE
  )
  
  # Need to make two reads, for the two different unsanitizers
  log_df_got_default <- read_logs()[1, ]
  log_df_got_custom <- read_logs(unsanitizer = dash2comma_replacer)[2, ]
  
  expect_equal(log_df_want[1, ], log_df_got_default)
  expect_equal(log_df_want[2, ], log_df_got_custom)
})
cleanup()
