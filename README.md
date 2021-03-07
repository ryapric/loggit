# Modern Logging for the R Ecosystem

Ryan Price <ryapric@gmail.com>

<!-- badges: start -->

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/loggit)](https://cran.r-project.org/package=loggit)
[![R-CMD-check](https://github.com/ryapric/loggit/workflows/R-CMD-check/badge.svg)](https://github.com/ryapric/loggit/actions)
[![Monthly
downloads](https://cranlogs.r-pkg.org/badges/loggit)](https://cran.r-project.org/package=loggit)
<!-- badges: end -->

-----

`loggit` is an [`ndJSON`](https://github.com/ndjson/ndjson-spec) logging
library for R software. It is blazingly fast when writing logs, and has
*zero* external dependencies. `loggit` can be as simple and unobstrusive
as you’d like, or as involved as your application needs it to be.

Please see below for some quick examples, and [read the
vignettes](https://cran.r-project.org/web/packages/loggit/vignettes/)
for the Getting Started guide, as well as some other use case examples.

## Why use `loggit`?

There are indeed several logging packages available for R. `loggit`,
however, takes a more modern approach approach to logging in R:

  - Opting to use the JSON format, which is parsable by most modern
    software
  - Designed with log streams in mind
  - Unobstrusive, yet highly flexible
  - Convenient ability to log data, then analyze that log data on the
    same host.

Additionally, the boilerplate to get going with `loggit` is minimal at
worst, only requiring you to point to the log file. If deploying your R
code in a container ecosystem, you don’t even need to do that, since
`loggit` will echo its formatted logs to `stdout`. No need to write
custom formatters, handlers, levels, etc. – ***just f\&ck\#n’
loggit\!***

## Quick Examples

The quickest way to get up & running with `loggit` is to… do nothing
special. `loggit`’s simplest functionality does its best to stay out of
your way. You’ll probably want to point it to a log file, though;
otherwise, logs will print to the console, but land in a tempfile.

``` r
library(loggit)
#> 
#> Attaching package: 'loggit'
#> The following objects are masked from 'package:base':
#> 
#>     message, stop, warning
# set_logfile("./loggit.log")

message("This is a message")
#> {"timestamp": "2021-03-07T15:08:44-0600", "log_lvl": "INFO", "log_msg": "This is a message"}
#> This is a message
warning("This is a warning")
#> {"timestamp": "2021-03-07T15:08:44-0600", "log_lvl": "WARN", "log_msg": "This is a warning"}
#> Warning in warning("This is a warning"): This is a warning
# stop("This actually throws a critical error, so I'm not actually going to run it here :)"))
#> {"timestamp": "2020-05-31T20:59:33-0500", "log_lvl": "ERROR", "log_msg": "This actually throws a critical error, so I'm not actually going to run it here :)"}
```

You can suppress each part of the console output separately (both the
`loggit` ndJSON and the regular R output) but the default is to post
both. Only the ndJSON is written to the log file.

You can also use the `loggit()` function directly to compose much more
custom logs, including ***entirely custom fields*** (and prevent
throwing actual status codes until you wish to handle them). `loggit`
doesn’t require that you set custom logger objects or anything like
that: just throw whatever you want at it, and it’ll become a structured
log.

``` r
loggit("ERROR", "This will log an error - but not actually throw one yet", rows = nrow(iris), anything_else = "you want to include")
#> {"timestamp": "2021-03-07T15:08:44-0600", "log_lvl": "ERROR", "log_msg": "This will log an error - but not actually throw one yet", "rows": "150", "anything_else": "you want to include"}

# Read log file into data frame to implement logic based on entries
logdata <- read_logs()
print(logdata)
#>                  timestamp log_lvl
#> 1 2021-03-07T15:08:44-0600    INFO
#> 2 2021-03-07T15:08:44-0600    WARN
#> 3 2021-03-07T15:08:44-0600   ERROR
#>                                                   log_msg rows
#> 1                                       This is a message     
#> 2                                       This is a warning     
#> 3 This will log an error - but not actually throw one yet  150
#>         anything_else
#> 1                    
#> 2                    
#> 3 you want to include
if (any(logdata$log_lvl == "ERROR")) {
  print("Errors detected somewhere in your code!") # but you can throw a stop() here, too, for example
}
#> [1] "Errors detected somewhere in your code!"
```

Again, [check out the
vignettes](https://cran.r-project.org/web/packages/loggit/vignettes/)
for more details\!

## Installation

You can install the latest CRAN release of `loggit` via
`install.packages("loggit")`.

Or, to get the latest development version from GitHub –

Via [devtools](https://github.com/hadley/devtools):

    devtools::install_github("ryapric/loggit")

Or, clone & build from source:

    cd /path/to/your/repos
    git clone https://github.com/ryapric/loggit.git loggit
    make install

To use the most recent development version of `loggit` in your own
package, you can include it in your `Remotes:` field in your DESCRIPTION
file:

    Remotes: github::ryapric/loggit

Note that packages being submitted to CRAN *cannot* have a `Remotes`
field. Refer
[here](https://cran.r-project.org/web/packages/devtools/vignettes/dependencies.html)
for more info.

## License

MIT
