% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{read_logs}
\alias{read_logs}
\title{Return log file as an R data frame}
\usage{
read_logs(logfile, unsanitizer)
}
\arguments{
\item{logfile}{Path to log file. Will default to currently-set log file.}

\item{unsanitizer}{Unsanitizer function to use. For more info on sanitizers,
please see the \link{sanitizers} section of the package documentation.}
}
\value{
A \code{data.frame}.
}
\description{
This function returns a \code{data.frame} containing all the logs in the provided
\code{ndjson} log file. If no explicit log file is provided, calling this function
will return a data frame of the log file currently pointed to by the \code{loggit}
functions.
}
\examples{
  set_logfile(file.path(tempdir(), "loggit.log"), confirm = FALSE)
  message("Test log message")
  read_logs()

}
