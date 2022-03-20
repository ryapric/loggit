# h/t to @jimhester and @yihui for this parse block:
# https://github.com/yihui/knitr/blob/dc5ead7bcfc0ebd2789fe99c527c7d91afb3de4a/Makefile#L1-L4
# Note the portability change as suggested in the manual:
# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Writing-portable-packages
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
RVERSION ?= $(shell R --version | awk 'NR == 1 { print $$3 }')

SHELL := /usr/bin/env bash -euo pipefail

all: check

check: clean build
	R CMD check --no-manual --as-cran $(PKGNAME)_$(PKGVERS).tar.gz

build: install_deps
	R CMD build .

install_deps:
	Rscript \
		-e 'if (!requireNamespace("remotes")) install.packages("remotes", repos = "https://cran.rstudio.com")' \
		-e 'remotes::install_deps(dependencies = TRUE)'

install: build
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

readme: install
	Rscript -e 'rmarkdown::render("README.Rmd")'

check-docker:
	@sed 's/RVERSION/$(RVERSION)/' Dockerfile-test > Dockerfile
	@docker build -t loggit:$(RVERSION) .
	@docker run --rm -it loggit:$(RVERSION)

clean-docker:
	@docker images | awk -F'\\s\\s+' '/loggit/ || /rocker/ { print $$1 ":" $$2 }' | xargs -I{} docker rmi {}

clean:
	@rm -rf \
		$(PKGNAME)_*.tar.gz \
		$(PKGNAME).Rcheck \
		README.md \
		Dockerfile
