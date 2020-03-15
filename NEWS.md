# Development version

- Remove `dplyr` and `jsonlite` from `Imports`. This makes `loggit` entirely
  free from external dependencies.

- Removed `log_detail` as an explicit argument to `loggit()`. This is a
  non-breaking change, since `loggit()` will still pick up and log that field if
  provided, but it is no longer a formal argument.

- `loggit()` no longer complains that a persistent log file is not set, and
  instead relies on the user to take note of the logfile's location in the
  assigned tempdir.

- Configuration functions are all now in snake-case, e.g.
  `set_timestamp_format()` instead of `setTimestampFormat()`.

- `set_timestamp_format()` now defaults to ISO-8601 time format. The function
  itself still provides no means to set a timezone, and this is deliberate. This
  ensures that all software on the host reports identical timezone data by
  default.

# loggit 1.2.0

- Add error on calls to loggit(), indicating breaking changes upcoming in v2.0.
  Users can suppress the error by running agree_to_upcoming_loggit_updates()
  once anywhere in their script or package before making a call to loggit().

# loggit version 1.1.1

- Automatically coerce any entries for 'log_lvl' and 'log_msg' fields to be
  character.

- (Github-only): loggit() no longer allows for a data frame to be passed as an
  argument; the underlying code was not writen very well, and I got ahead of
  myself in throwing it in there. loggit() is, however, still vectorized by
  nature, so users can still pass vectors to, for example, the log_detail
  argument, and values will be recycled according to R's usual recycling rules.

# loggit version 1.1.0

- Add get_logs(), which returns a data frame of a provided log file. Returns the
  current log file by default.

- (Github-only): loggit() now allows for a data frame to be passed as the sole
  argument, and have its results be logged. Required column names are the same
  as the first two arguments to loggit(): "log_lvl" and "log_msg". Any
  additional number of columns can be supplied.

# loggit version 1.0.0

- This is the first CRAN release of the loggit package. Included features are
  the masking functions for base R's exception handlers (message, warning, and
  stop), as well as the loggit() function, which is wrapped in those calls.
