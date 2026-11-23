
# ============================================================
# Tests: ERP Data Validation
# ============================================================

source(
  testthat::test_path(
    "..", "..", "R", "utils", "validate_erp_data.R"
  )
)

# Example of valid ERP data
valid_data <- data.frame(
  subject = c("sub-01", "sub-01", "sub-02", "sub-02"),
  condition = c("control", "control", "experimental", "experimental"),
  trial = c(1, 1, 1, 1),
  channel = c("Pz", "Pz", "Pz", "Pz"),
  time_ms = c(-200, -196, -200, -196),
  amplitude_uv = c(0.2, 0.4, 0.3, 0.5)
)

test_that("valid ERP data passes validation", {
  expect_true(validate_erp_data(valid_data))
})

test_that("missing columns are detected", {
  incomplete_data <- valid_data[
    , names(valid_data) != "amplitude_uv"
  ]
  
  expect_error(
    validate_erp_data(incomplete_data),
    "Missing required columns"
  )
})

test_that("missing amplitude values are detected", {
  invalid_data <- valid_data
  invalid_data$amplitude_uv[1] <- NA_real_
  
  expect_error(
    validate_erp_data(invalid_data),
    "Non-finite values"
  )
})

test_that("duplicate observations are detected", {
  duplicated_data <- rbind(
    valid_data,
    valid_data[1, ]
  )
  
  expect_error(
    validate_erp_data(duplicated_data),
    "Duplicate observations"
  )
})

test_that("empty datasets are rejected", {
  empty_data <- valid_data[0, ]
  
  expect_error(
    validate_erp_data(empty_data),
    "Input dataset is empty"
  )
})
