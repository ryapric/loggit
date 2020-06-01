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
  
  log_df_got <- read_logs(get_logfile(), log_format = "ndjson")
  
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
  log_df_got <- read_logs()
  
  expect_equal(log_df_want, log_df_got)
})
cleanup()
