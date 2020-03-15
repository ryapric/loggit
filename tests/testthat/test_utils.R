context("Utility functions")


test_that("bind_rows_loggit works", {
  df1 <- data.frame(a = c(1, 2, 3))
  df2 <- data.frame(b = c(1, 2, 3))
  df_out <- data.frame(
    a = c(1, 2, 3, NA, NA, NA),
    b = c(NA, NA, NA, 1, 2, 3)
  )
  expect_equal(bind_rows_loggit(df1, df2), df_out)
})


test_that("log_rotate works", {
  fail()
})


cleanup()
