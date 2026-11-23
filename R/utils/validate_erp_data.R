
# ============================================================
# Validate ERP Input Data
# ============================================================

validate_erp_data <- function(data) {
  
  required_columns <- c(
    "subject",
    "condition",
    "trial",
    "channel",
    "time_ms",
    "amplitude_uv"
  )
  
  # Check required columns
  missing_columns <- setdiff(
    required_columns,
    names(data)
  )
  
  if (length(missing_columns) > 0) {
    stop(
      "Missing required columns: ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  # Check that data is not empty
  if (nrow(data) == 0) {
    stop("Input dataset is empty.")
  }
  
  # Check required identifiers
  identifier_columns <- c(
    "subject",
    "condition",
    "trial",
    "channel"
  )
  
  for (column in identifier_columns) {
    if (anyNA(data[[column]])) {
      stop("Missing values found in column: ", column)
    }
  }
  
  # Check numeric columns
  numeric_columns <- c("time_ms", "amplitude_uv")
  
  for (column in numeric_columns) {
    if (!is.numeric(data[[column]])) {
      stop("Column must be numeric: ", column)
    }
    
    if (any(!is.finite(data[[column]]))) {
      stop("Non-finite values found in column: ", column)
    }
  }
  
  # Check for duplicate observations
  observation_columns <- c(
    "subject",
    "condition",
    "trial",
    "channel",
    "time_ms"
  )
  
  if (anyDuplicated(data[observation_columns]) > 0) {
    stop("Duplicate observations found in input data.")
  }
  
  message("Input data validation passed.")
  
  invisible(TRUE)
}