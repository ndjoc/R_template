source(testthat::test_path(
  "..", "..", "R", "bids", "bids_parse_filename.R"
))
library(testthat)
test_that("BIDS filename entities are parsed correctly", {
  
  result <- bids_parse_filename(
    "sub-01_ses-02_task-rest_run-01_meg.fif"
  )
  
  expect_equal(result$sub, "01")
  expect_equal(result$ses, "02")
  expect_equal(result$task, "rest")
  expect_equal(result$run, "01")
  expect_equal(result$suffix, "meg")
  expect_equal(result$extension, ".fif")
})

test_that("BIDS filenames without sessions are parsed", {
  
  result <- bids_parse_filename(
    "sub-03_task-motor_meg.fif"
  )
  
  expect_equal(result$sub, "03")
  expect_equal(result$task, "motor")
  expect_equal(result$suffix, "meg")
  expect_null(result$ses)
})

test_that("BIDS filenames with multiple entities are parsed", {
  
  result <- bids_parse_filename(
    "sub-01_ses-01_task-rest_acq-highres_run-02_meg.fif"
  )
  
  expect_equal(result$acq, "highres")
  expect_equal(result$run, "02")
})
