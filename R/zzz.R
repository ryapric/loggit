.onLoad <- function(libname, pkgname) {
  set_logfile(confirm = FALSE)
  set_timestamp_format(confirm = FALSE)
  set_rotate_lines(NULL, confirm = FALSE)
  invisible(NULL)
}

.onUnload <- function(libpath) {
  for (i in names(.config)) {
    .config[[i]] <- NULL
  }
  invisible(NULL)
}
