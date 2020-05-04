Modern Logging for the R Ecosystem
==================================
Ryan Price <ryapric@gmail.com>

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/loggit)](https://cran.r-project.org/package=loggit)
[![Build
Status](https://travis-ci.org/ryapric/loggit.svg?branch=master)](https://travis-ci.org/ryapric/loggit)
[![Monthly
downloads](https://cranlogs.r-pkg.org/badges/loggit)](https://cran.r-project.org/package=loggit)

------------------------------------------------------------------------

`loggit` is an [`ndJSON`](https://github.com/ndjson/ndjson-spec) logging library
for R software. It is blazingly fast when writing logs, and has _zero_ external
dependencies. `loggit` can be as simple and unobstrusive as you'd like, or as
involved as your application needs it to be.

Please [read the
vignettes](https://cran.r-project.org/web/packages/loggit/vignettes/) for the
Getting Started guide, as well as some use case examples.

Why use `loggit`?
-----------------

There are indeed several logging packages available for R. `loggit`, however,
takes a more modern approach approach to logging in R:

- Opting to use the JSON format, which is parsable by most modern software
- Designed with log streams in mind
- Unobstrusive, yet highly flexible
- Convenient ability to log data, then analyze that log data on the same host.

Additionally, the boilerplate to get going with `loggit` is minimal at worst,
only requiring you to point to the log file. If deploying your R code in a
container ecosystem, you don't even need to do that, since `loggit` will
echo its formatted logs to `stdout`. No need to write custom formatters,
handlers, levels, etc. -- ***just f&ck#n' loggit!***

Installation
------------

You can install the latest CRAN release of `loggit` via
`install.packages("loggit")`.

Or, to get the latest development version from GitHub --

Via [devtools](https://github.com/hadley/devtools):

    devtools::install_github("ryapric/loggit")

Or, clone & build from source:

    cd /path/to/your/repos
    git clone https://github.com/ryapric/loggit.git loggit
    make install

To use the most recent development version of `loggit` in your own package, you
can include it in your `Remotes:` field in your DESCRIPTION file:

    Remotes: github::ryapric/loggit

Note that packages being submitted to CRAN *cannot* have a `Remotes` field.
Refer
[here](https://cran.r-project.org/web/packages/devtools/vignettes/dependencies.html)
for more info.

License
-------

MIT
