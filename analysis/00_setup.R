
# ============================================================
# R Analysis Template
# Project Setup
# ============================================================

# Load project configuration
config_file <- here::here("config", "config.yaml")

if (!file.exists(config_file)) {
  stop("Configuration file not found: ", config_file)
}

config <- yaml::read_yaml(config_file)

# Validate required configuration entries
required_paths <- c("outputs", "figures", "tables", "reports")

missing_paths <- setdiff(required_paths, names(config$paths))

if (length(missing_paths) > 0) {
  stop(
    "Missing paths in config/config.yaml: ",
    paste(missing_paths, collapse = ", ")
  )
}

if (is.null(config$reproducibility$random_seed)) {
  stop("Random seed is missing from the configuration.")
}

# Set random seed
set.seed(config$reproducibility$random_seed)

# Create output directories
output_dirs <- unlist(
  config$paths[required_paths],
  use.names = FALSE
)

for (dir in output_dirs) {
  dir.create(
    here::here(dir),
    recursive = TRUE,
    showWarnings = FALSE
  )
}

message("Project setup complete.")
message("Project root: ", here::here())
message("Configuration loaded: ", config_file)