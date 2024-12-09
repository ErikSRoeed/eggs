library(testthat)
for(file in dir("R", full.names = TRUE)) source(file)
test_dir("tests/testthat/")
