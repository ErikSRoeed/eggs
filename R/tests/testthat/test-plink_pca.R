
test_that("Can instantiate new plink_pca object without error, warning, or message", {
  expect_no_error({
    inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec")
  })
  expect_no_warning({
    inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec")
  })
  expect_no_message({
    inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec")
  })
})

test_that("Eigenvalues are loaded correctly", {
  inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec")
  priv <- inst$.__enclos_env__$private

  # Expect same properties as in tests/test.eigenval
  expect_vector(priv$eigenvalues, ptype = numeric(), size = 3)
})

test_that("Eigenvectors are loaded correctly", {
  inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec", "TestID")
  priv <- inst$.__enclos_env__$private

  # Expect properties accord with input file and user input
  expect_equal(
    colnames(priv$eigenvectors),
    c("TestID", "PC1", "PC2", "PC3")
  )
  expect_in(
    class(priv$eigenvectors),
    c("tbl_df", "tbl", "data.frame")
  )
  expect_equal(
    ncol(priv$eigenvectors),
    4
  )
  expect_equal(
    nrow(priv$eigenvectors),
    6
  )
})

test_that("Method get_coordinates returns expected output", {
  inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec", "TestID")
  priv <- inst$.__enclos_env__$private

  expect_equal(
    inst$get_coordinates(pc = c(1)),
    priv$eigenvectors[c("TestID", "PC1")]
  )
  expect_equal(
    inst$get_coordinates(pc = c(1, 2)),
    priv$eigenvectors[c("TestID", "PC1", "PC2")]
  )
})

test_that("Method get_variance_explained returns expected output", {
  inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec")

  expect_equal(
    inst$get_variance_explained(pc = c(1, 2, 3), as_percent = FALSE),
    c(0.5, 0.3, 0.2)
  )
  expect_equal(
    inst$get_variance_explained(pc = c(1, 2, 3), as_percent = TRUE),
    c(50, 30, 20)
  )
  expect_vector(inst$get_variance_explained(pc = c(1)), ptype = numeric(), size = 1)
})

test_that("Active field sample_ids returns expected output", {
  inst <- plink_pca$new("../testdata/test.eigenval", "../testdata/test.eigenvec")
  expect_equal(inst$sample_ids, paste("Sample", 1 : 6, sep = ""))
})
