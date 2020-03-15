context("Handler replacements")

test_that("message works as it does in base R", {
  expect_message(base::message("this is a message test"))
  expect_message(loggit::message("this is also a message test", echo = FALSE))
})

test_that("warning works as it does in base R", {
  expect_warning(base::warning("this is a warning test"))
  expect_warning(loggit::warning("this is also a warning test", echo = FALSE))
})

test_that("stop works as it does in base R", {
  expect_error(base::stop("this is a stop test"))
  expect_error(loggit::stop("this is also a stop test", echo = FALSE))
})

test_that("stopifnot works as it does in base R", {
  expect_error(base::stopifnot(is.numeric("this is a stopifnot test")))
  expect_error(loggit::stopifnot(is.numeric("this is also a stopifnot test"), echo = FALSE))
})

cleanup()
