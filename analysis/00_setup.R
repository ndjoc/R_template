# Load required packages
library(yaml)
library(tidyverse)
library(here)

# Load project configuration
config <- yaml::read_yaml(
  here::here("config", "config.yaml")
)

# Set random seed
set.seed(config$reproducibility$random_seed)

# Create output directories
output_dirs <- unlist(config$paths, use.names = FALSE)

for (dir in output_dirs) {
  dir.create(
    here::here(dir),
    recursive = TRUE,
    showWarnings = FALSE
  )
}

message("Project setup complete.")
