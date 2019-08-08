context("loggit")

test_that("loggit writes to JSON file", {
  init_msg <- "Initial log"
  msg <- "this is a message"
  warn <- "this is a warning"
  err <- "this is an error"
  detail <- "and this is error detail"
  
  expect_message(message(msg))
  expect_warning(warning(warn))
  expect_error(stop(err, log_detail = detail))
  
  logs_json <- jsonlite::read_json(file.path(.config$logfile), simplifyVector = TRUE)
  
  expect_equal(nrow(logs_json), 4)
  expect_equal(logs_json$log_lvl, c("INFO", "INFO", "WARN", "ERROR"))
  expect_equal(logs_json$log_msg, c(init_msg, msg, warn, err))
  expect_equal(logs_json$log_detail[4], detail)
})

file.remove(.config$logfile)


test_that("loggit custom levels behave as expected", {
  expect_error(loggit(log_lvl = "foo", log_msg = "bar"))
  expect_message(loggit(log_lvl = "foo", log_msg = "bar", custom_log_lvl = TRUE))
})

file.remove(.config$logfile)


context("Log file can be returned")

test_that("Log file is returned via get_logs()", {
  message("Test log entry")
  x <- get_logs()
  expect_true("data.frame" %in% class(x))
  expect_equal(nrow(x), 2)
  x <- get_logs(as_df = FALSE)
  expect_equal(class(x), "list")
  expect_false("data.frame" %in% class(x))
  expect_length(x, 2)
})

file.remove(.config$logfile)
