# loggit version 1.1.0

- Add logrotate(), which is designed to emulate the 'logrotate' utility from UNIX-alike systems.

- Add get_logs(), which returns a data frame of a provided log file. Returns the current log file by default.

- loggit() now allows for a data frame to be passed as the sole argument, and have
its results be logged. Required column names are the same as the first two
arguments to loggit(): "log_lvl" and "log_msg". Any additional number of columns
can be supplied.

# loggit version 1.0.0

This is the first CRAN release of the loggit package. Included features are the
masking functions for base R's exception handlers (message, warning, and stop),
as well as the loggit() function, which is wrapped in those calls.
