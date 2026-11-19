# Load required packages
library(yaml)
library(tidyverse)
library(here)

# Load project configuration
config <- yaml::read_yaml(
  here::here("config", "config.yml")
)

# Set random seed
set.seed(config$reproducibility$random_seed)

# Create output directories if necessary
dir.create(config$paths$figures, recursive = TRUE, showWarnings = FALSE)
dir.create(config$paths$tables, recursive = TRUE, showWarnings = FALSE)

message("Project setup complete.")