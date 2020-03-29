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


test_that("rotate_logs works", {
  for (i in 1:100) {
    loggit("INFO", paste0("log_", i), echo = FALSE)
  }
  
  rotate_lines <- 50
  rotate_logs(rotate_lines)
  
  log_df <- read_logs()
  
  expect_true(nrow(log_df) == rotate_lines)
})
cleanup()
