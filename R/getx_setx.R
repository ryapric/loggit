# SetLogLevel <- function(level = "INFO") {
#   stopifnot(level %in% c("INFO", "WARN", "STOP"))
#   assign("loglevel", level, envir = .rloggingOptions)
# }
# 
# GetLogLevel <- function() {
#   get("loglevel", envir = .rloggingOptions)
# }
# 
# SetTimeStampFormat <- function(ts.format="[%Y-%m-%d %H:%M:%S]") {
#   assign("ts.format", ts.format, envir = .rloggingOptions)
# }
# 
# GetTimeStampFormat <- function() {
#   get("ts.format", envir = .rloggingOptions)
# }
# 
# SetFilenameSuffixes <- function(file.name.suffixes = list(INFO = "message",
#                                                           WARN = "warning",
#                                                           STOP = "stop")) {
#   # Check that a list of length=3 is passed to this function:
#   if (!is.list(file.name.suffixes) | length(file.name.suffixes) != 3) {
#     stop("argument file.name.suffixes must must be a list of length 3")
#   }
#   
#   # Check if the list of suffixes contains INFO, WARN, and STOP. If not,
#   # Return a message indicating the missing elements of file.name.suffixes
#   missing.elements <- setdiff(c("INFO", "WARN", "STOP"),
#                               names(file.name.suffixes))
#   
#   if (length(missing.elements) > 0) {
#     stop("argument file.name.suffixes is missing element(s): ",
#          paste0(missing.elements, collapse = ", "))
#   }
#   
#   assign("file.name.suffixes", file.name.suffixes, envir = .rloggingOptions)
# }
# 
# GetFilenameSuffixes <- function() {
#   get("file.name.suffixes", envir = .rloggingOptions)
# }
# 
# SetLogFile <- function(base.file = "rlogging.log", folder = getwd(),
#                        split.files = FALSE) {
#   assign("split.files", split.files, envir = .rloggingOptions)
#   
#   if (is.null(base.file)) {
#     assign("logfile.base", NULL, envir = .rloggingOptions)
#   } else {
#     assign("logfile.base", file.path(folder, base.file),
#            envir = .rloggingOptions)
#   }
# }
# 
# GetLogFile <- function(level) {
#   base.file <- get("logfile.base", envir = .rloggingOptions)
#   split.files <- get("split.files", envir = .rloggingOptions)
#   if (!missing(level)) {
#     if (!split.files) {
#       warning("level = ", level, "provided to GetLogFile(), but log files
#               are not split. Ignoring parameter.")
#       base.file
#     } else {
#       file.name.suffix <- get(level, GetFilenameSuffixes())
#       replacement <- paste0("\\1", "_", file.name.suffix, "\\2")
#       gsub("(.+?)(\\.[^.]*$|$)", replacement, base.file)
#     }
#   } else {
#     if (split.files) {
#       stop("log files are split, but no level parameter provided to
#               GetLogFile().")
#     } else {
#       base.file
#     }
#   }
# }
