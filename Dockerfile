FROM rocker/tidyverse:3.6.2

WORKDIR /root
COPY . ./loggit
WORKDIR /root/loggit

CMD ["Rscript", "-e", "devtools::check()"]
