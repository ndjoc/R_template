# ============================================================
# R Analysis Template
# Additional R Package Installation
# ============================================================
#
# Purpose:
#   Install additional R packages from CRAN and GitHub.
#
# Note:
#   Core dependencies are managed by Pixi.
#   This script handles additional packages not included
#   in the Pixi environment.
#
# Usage:
#   pixi run install-packages
#
# ============================================================


# ------------------------------------------------------------
# 1. Configuration
# ------------------------------------------------------------

CRAN_REPO <- "https://cloud.r-project.org"


# ------------------------------------------------------------
# 2. Helper functions
# ------------------------------------------------------------

install_cran <- function(packages) {
  
  missing_packages <- packages[
    !vapply(
      packages,
      requireNamespace,
      quietly = TRUE,
      FUN.VALUE = logical(1)
    )
  ]
  
  if (length(missing_packages) == 0) {
    message("All CRAN packages are already installed.")
    return(invisible(NULL))
  }
  
  message(
    "Installing CRAN packages: ",
    paste(missing_packages, collapse = ", ")
  )
  
  install.packages(
    missing_packages,
    repos = CRAN_REPO
  )
}


install_github <- function(packages) {
  
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install_cran("remotes")
  }
  
  if (!requireNamespace("remotes", quietly = TRUE)) {
    stop("Could not install the 'remotes' package.")
  }
  
  for (repo in packages) {
    
    package_name <- sub(".*/", "", repo)
    
    if (requireNamespace(package_name, quietly = TRUE)) {
      message(package_name, " is already installed.")
      next
    }
    
    message("Installing GitHub package: ", repo)
    
    remotes::install_github(
      repo,
      dependencies = TRUE,
      upgrade = "never"
    )
  }
}


# ------------------------------------------------------------
# 3. Additional CRAN packages
# ------------------------------------------------------------

cran_packages <- c(
  
  # BIDS and data handling
  "bidsr",
  
  # Neuroimaging visualization
  "ggseg",
  
  # Additional utilities
  "janitor",
  "skimr",
  "naniar",
  
  # Statistical analysis
  "performance",
  "parameters",
  "see",
  "effectsize"
)


# ------------------------------------------------------------
# 4. GitHub packages
# ------------------------------------------------------------

github_packages <- c(
  "ggsegverse/ggsegGlasser"
)


# ------------------------------------------------------------
# 5. Installation
# ------------------------------------------------------------

message("\n========================================")
message("Additional R Package Installation")
message("========================================\n")


install_cran(cran_packages)

install_github(github_packages)


# ------------------------------------------------------------
# 6. Check installations
# ------------------------------------------------------------

github_package_names <- vapply(
  github_packages,
  function(repo) sub(".*/", "", repo),
  character(1)
)

all_packages <- c(
  cran_packages,
  github_package_names
)

package_status <- data.frame(
  package = all_packages,
  installed = vapply(
    all_packages,
    requireNamespace,
    quietly = TRUE,
    FUN.VALUE = logical(1)
  )
)

print(package_status, row.names = FALSE)

if (any(!package_status$installed)) {
  stop(
    "Some packages could not be installed: ",
    paste(
      package_status$package[!package_status$installed],
      collapse = ", "
    )
  )
}

message("\nAll requested packages are installed.")