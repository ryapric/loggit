context("Handler replacements")

test_that("message works as it does in base R", {
  expect_message(base::message("this is a message test"))
  expect_message(loggit::message("this is also a message test", echo = FALSE))
  
  # Multiple args are concatenated
  captured_output <- capture_output(
    loggit::message('this should be ', 'concatenated ', 'in the log')
  )
  expect_true(grepl('this should be concatenated in the log', captured_output))
})

test_that("warning works as it does in base R", {
  expect_warning(base::warning("this is a warning test"))
  expect_warning(loggit::warning("this is also a warning test", echo = FALSE))
  
  # Multiple args are concatenated
  suppressWarnings(
    captured_output <- capture_output(
      loggit::warning('this should be ', 'concatenated ', 'in the log')
    )
  )
  expect_true(grepl('this should be concatenated in the log', captured_output))
})

test_that("stop works as it does in base R", {
  expect_error(base::stop("this is a stop test"))
  expect_error(loggit::stop("this is also a stop test", echo = FALSE))
  
  # Multiple args are concatenated
  # Test looks different to get around the stop() call
  expect_error(loggit::stop('this should be ', 'concatenated ', 'in the log', echo = FALSE))
  logdata <- read_logs()
  logdata <- logdata[logdata$log_lvl == 'ERROR', ]
  logdata <- logdata[nrow(logdata), ]
  expect_true(logdata$log_msg == 'this should be concatenated in the log')
})

cleanup()
