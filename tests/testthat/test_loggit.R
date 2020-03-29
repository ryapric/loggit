# ===
context("loggit handlers")

test_that("loggit writes handler messages to file", {
  msg <- "this is a message"
  warn <- "this is a warning"
  err <- "this is an error"
  
  expect_message(message(msg, echo = FALSE))
  expect_warning(warning(warn, echo = FALSE))
  expect_error(stop(err, echo = FALSE))
  
  logs_json <- read_logs()
  
  expect_equal(nrow(logs_json), 3)
  expect_equal(logs_json$log_lvl, c("INFO", "WARN", "ERROR"))
  expect_equal(logs_json$log_msg, c(msg, warn, err))
})
cleanup()


# ===
context("Custom log levels")

test_that("loggit custom levels behave as expected", {
  expect_error(loggit(log_lvl = "foo", log_msg = "bar", echo = FALSE))
  # There isn't really anything to test here, so just run it and let it succeed
  loggit(log_lvl = "foo", log_msg = "bar", echo = FALSE, custom_log_lvl = TRUE)
})
cleanup()


# ===
context("Log file can be returned as data.frame")

test_that("Log file is returned via read_logs()", {
  message("msg", echo = FALSE)
  log_df <- read_logs()
  expect_true("data.frame" %in% class(log_df))
})
cleanup()
