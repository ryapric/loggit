# loggit 2.1.1

This is a small bugfix release for CRAN's sake that fixes two tests that would
sporadically fail; they relied on timestamps being equivalent between `want` and
`got` invocations.

# loggit 2.1.0

- Add `sanitizer` argument to `loggit()`, and an `unsanitizer` argument to
  `read_logs()`. `loggit` chooses to reimplement basic JSON parsing
  funcitonality instead of requiring a more full-featured external JSON library
  like `jsonlite`. This reimplementation is string-pattern-based, and not based
  on a more formal specification of JSON using an AST. As such, it isn't
  brittle, per se, but it *is* weak to invalid JSON characters such as embedded
  newlines, curly braces, double-quotes, some occurrences of commas or colons,
  and the like.
  
  Sanitizers are functions allow for custom replacements of invalid (nd)JSON
  characters in the submitted log data. Unsanitizer functions perform the
  opposite action: replacing sanitized output with their original values when
  read back inttohe R session. If not provided, `loggit()` and `read_logs()`
  will invoke the default sanitizer table, which (currently) maps string
  replacements as follows:

  | Character | Replacement in log file |
  |:--------- | :---------------------- |
  | `{`       | `__LEFTBRACE__`         |
  | `}`       | `__RIGHTBRACE__`        |
  | `"`       | `__DBLQUOTE__`          |
  | `,`       | `__COMMA__`             |
  | `\r`      | `__CR__`                |
  | `\n`      | `__LF__`                |

  Users may specify their own (un)sanitizers as functions that take & return
  single strings, though they are regardless encouraged to not include invalid
  characters in the logs in the first place. Please refer to the documentation
  for more details.

- Removed `log_format` from `read_ndjson()`, because that was silly.

- Removed some erroneous functions as exports in the `NAMESPACE`.

# loggit 2.0.1

- Change behavior of handler masks to respect multiple arguments. Achieved by
  changing explicit list indexing to `paste(..., collapse = "")` (#12).

- Remove `loggit::stopifnot` tests, since `stopifnot()` is not provided as a
  handler mask by this package (`stopifnot()` has no custom messaging mechanic
  to log).

# loggit 2.0.0

- `loggit()` now logs explicitly to `ndjson`-formatted log files. This is
  handled internally by the `write_ndjson()` function. Each log entry is
  self-contained on its own line, as its own JSON object. Previously, the log
  files were each a single JSON *array*, with JSON objects as the elements. This
  change provides several benefits over the old way of logging.

  Please note that this change means that log entries should not contain any
  embedded newline characters (`\r`, `\n`, or `\r\n`), as this will break the
  logging format of the file. Your logs will still be written (with a
  `base::warning`), but parsing the data with external tools or the included
  `read_logs()` function may not behave correctly. `loggit` could one day
  enforce these content rules internally, but the decision for now is to stay
  out of the way of the user code generating the logs, and put the onus of
  correction on the developer.
  
  Note that despite the significant backend behavioral changes presented here,
  the user-facing API for this package has changed very little (documented
  below).

- Remove `dplyr` and `jsonlite` from `Imports`. This makes `loggit` entirely
  free from external dependencies.

- Added `rotate_logs()`, which rotates the log file on disk based on its line
  count. This is *not* an automated process, as depending on the size of your
  log file, this could cause performance degradation if called on every *n*th
  write. See function docs for more details.

- Added two vignettes: Getting Started, and Data Validation.

- `get_logs()` was renamed to `read_logs()`.

- Removed `log_detail` as an explicit argument to `loggit()`. This is a
  non-breaking change, since `loggit()` will still pick up and log that field if
  provided, but it is no longer a formal argument.

- `loggit()` no longer complains that a persistent log file is not set, and
  instead relies on the user to take note of the logfile's location in the
  assigned tempdir. This can be avoided entirely by setting the log file
  explicitly at runtime, as has always been the case.

- All configuration `set` and `get` functions are all now in snake-case, e.g.
  `set_logfile()` instead of `setLogFile()`.

- `set_timestamp_format()` now defaults to ISO-8601 time format, i.e.
  `YYYY-MM-DDTHH:MM:SS+z`. The function itself still provides no means to set a
  timezone, and this is deliberate. This ensures that all software on the host
  reports identical timezone data by default.

- Removed package startup message; the previous message would have broken
  formatting consistency if capturing logs via `stdout`/`stderr`.

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
