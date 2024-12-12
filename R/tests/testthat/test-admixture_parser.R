
ACTUAL_K_VALUES <- c(1, 2, 3)
ACTUAL_CV_ERROR <- c(0.3, 0.25, 0.225)
ACTUAL_K_MIN_ERROR <- 3
ACTUAL_N_SAMPLES <- 5

test_that("Can instantiate new admixture_parser object without error, warning, or message", {
  expect_no_error({
    inst <- admixture_parser$new("../testdata/test_admixture", paste("ID", seq(5)), "TestID")
  })
  expect_no_warning({
    inst <- admixture_parser$new("../testdata/test_admixture", paste("ID", seq(5)), "TestID")
  })
  expect_no_message({
    inst <- admixture_parser$new("../testdata/test_admixture", paste("ID", seq(5)), "TestID")
  })
})

test_that("K values and CV errors are parsed correctly", {
  inst <- admixture_parser$new("../testdata/test_admixture", paste("ID", seq(5)), "TestID")
  expect_equal(inst$k_values, ACTUAL_K_VALUES)
  expect_equal(inst$cv_errors, ACTUAL_CV_ERROR)
  expect_equal(inst$k_min_error, ACTUAL_K_MIN_ERROR)
})

test_that("Assignments are parsed correctly", {
  inst <- admixture_parser$new("../testdata/test_admixture", paste("ID", seq(5)), "TestID")

  for (k in ACTUAL_K_VALUES) {
    assignments <- inst$get_assignments(k)
    ids_are_strings <- typeof(assignments[[1]]) == "character"
    assignments_are_floats <- all(unlist(lapply(assignments[-1], function(v) typeof(unlist(v)) == "double")))
    dimensions_are_correct <- all(dim(assignments) == c(ACTUAL_N_SAMPLES, k + 1))

    if (ids_are_strings & assignments_are_floats & dimensions_are_correct) next

    fail()
  }

  succeed()

})

test_that("Instantiator function returns identical output as direct instantiation", {
  inst_function <- parse_admixture("../testdata/test_admixture", paste("ID", seq(5)), "TestID")
  inst_direct <- admixture_parser$new("../testdata/test_admixture", paste("ID", seq(5)), "TestID")
  expect_equal(inst_function, inst_direct)
})
