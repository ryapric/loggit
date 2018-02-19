## Resubmission
This is a resubmission. In this version I have:

* Changed the functionality of the loggit() function to instead write to a file
in tempdir(), unless the user explicitly requests a different output
location/file

* Removed the redundant "in R" from the DESCRIPTION file title field

* Added single quotes around software/package names in DESCRIPTION

* Added more executable examples to the .Rd files

## Test environments
* Local Windows 10 install, R 3.4.3
* Local Lubuntu 17.10 (VirtualBox), R 3.4.3
* win-builder (devel)

## R CMD check results
There were no ERRORs, WARNINGs.

There was 1 NOTE:

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Ryan Price <ryapric@gmail.com>'

New submission

## Downstream dependencies
There are no downstream/reverse dependencies for this package, as it is an
initial release.
