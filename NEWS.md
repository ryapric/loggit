# loggit version 1.1.1

- Automatically coerce any entries for 'log_lvl' and 'log_msg' fields to be character,.

- (Github-only): loggit() no longer allows for a data frame to be passed as an argument; the underlying code was not writen very well, and I got ahead of myself in throwing it in there. loggit() is, however, still vectorized by nature, so users can still pass vectors to, for example, the log_detail argument, and values will be recycled according to R's usual recycling rules.

# loggit version 1.1.0

- Add get_logs(), which returns a data frame of a provided log file. Returns the current log file by default.

- (Github-only): loggit() now allows for a data frame to be passed as the sole argument, and have
its results be logged. Required column names are the same as the first two
arguments to loggit(): "log_lvl" and "log_msg". Any additional number of columns
can be supplied.

# loggit version 1.0.0

- This is the first CRAN release of the loggit package. Included features are the
masking functions for base R's exception handlers (message, warning, and stop),
as well as the loggit() function, which is wrapped in those calls.
