Sys.setenv(TAR = "/bin/tar")
devtools::install_github("ropensci/piggyback@87f71e8")
# https://github.com/cgpu/sbas-nf/issues/4
devtools::install_github("IRkernel/repr@505a052")
install.packages("runjags", repos = "https://cloud.r-project.org/")