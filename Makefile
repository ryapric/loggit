# h/t to @jimhester and @yihui for this parse block:
# https://github.com/yihui/knitr/blob/dc5ead7bcfc0ebd2789fe99c527c7d91afb3de4a/Makefile#L1-L4
# Note the portability change as suggested in the manual:
# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Writing-portable-packages
PKGNAME = `sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION`
PKGVERS = `sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION`

SHELL := /usr/bin/env bash -euo pipefail


all: check

readme:
	Rscript -e 'rmarkdown::render("README.Rmd")'

build:
	make -s readme
	R CMD build .

check: build
	R CMD check --no-manual --as-cran $(PKGNAME)_$(PKGVERS).tar.gz

check-docker:
	@sed 's/RVERSION/$(RVERSION)/' Dockerfile-test > Dockerfile
	@docker build -t loggit:$(RVERSION) .
	@docker run --rm -it loggit:$(RVERSION)

clean-docker:
	@docker images | awk -F'\\s\\s+' '/loggit/ { print $$1 ":" $$2 }' | xargs -I{} docker rmi {}

install_deps:
	Rscript \
	-e 'if (!requireNamespace("remotes")) install.packages("remotes")' \
	-e 'remotes::install_deps(dependencies = TRUE)'

install: install_deps build
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

clean:
	@rm -rf $(PKGNAME)_$(PKGVERS).tar.gz $(PKGNAME).Rcheck
