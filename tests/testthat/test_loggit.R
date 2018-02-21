# Prevent warning from being raised by testthat's loggit() call
.config$seenmessage_old <- .config$seenmessage
.config$seenmessage <- TRUE



context("Handler replacements")

test_that("message works as it does in base R", {
  expect_message(base::message("this is a message test"))
  expect_message(loggit::message("this is also a message test"))
})

test_that("warning works as it does in base R", {
  expect_warning(base::warning("this is a warning test"))
  expect_warning(loggit::warning("this is also a warning test"))
})

test_that("stop works as it does in base R", {
  expect_error(base::stop("this is a stop test"))
  expect_error(loggit::stop("this is also a stop test"))
})

test_that("stopifnot works as it does in base R", {
  expect_error(base::stopifnot(is.numeric("this is a stopifnot test")))
  expect_error(loggit::stopifnot(is.numeric("this is also a stopifnot test")))
})

file.remove(.config$logfile)



context("File output")

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



context("Log file can be returned")

test_that("Log file is returned via get_logs()", {
  message("Test log entry")
  x <- get_logs()
  expect_equal(class(x), "data.frame")
  expect_equal(nrow(x), 2)
  x <- get_logs(as_df = FALSE)
  expect_equal(class(x), "list")
  expect_false(class(x) == "data.frame")
  expect_length(x, 2)
})

file.remove(.config$logfile)

.config$seenmessage <- .config$seenmessage_old
