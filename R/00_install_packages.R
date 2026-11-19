# ============================================================
# MEG Analysis Template
# Additional R Package Installation
# ============================================================
#
# Purpose:
#   Install additional R packages from CRAN and GitHub.
#
# Note:
#   Core dependencies are managed by Pixi.
#   This script handles packages that are not managed by Pixi.
#
# Usage:
#   pixi run Rscript analysis/00_install_packages.R
#
# ============================================================


# ------------------------------------------------------------
# 1. Configuration
# ------------------------------------------------------------

CRAN_REPO <- "https://cloud.r-project.org"

# Install optional packages as well?
install_all <- "--all" %in% commandArgs(trailingOnly = TRUE)


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
  
  # Brain atlas visualization
  "ggsegverse/ggsegGlasser"
  
)


# ------------------------------------------------------------
# 5. Optional Bayesian packages
# ------------------------------------------------------------

bayesian_cran_packages <- c(
  "brms"
)


# ------------------------------------------------------------
# 6. Installation
# ------------------------------------------------------------

message("\n========================================")
message("Package Installation")
message("========================================\n")


# Standard CRAN packages
install_cran(cran_packages)


# GitHub packages
install_github(github_packages)


# Optional Bayesian packages
if (install_all) {
  
  message("\nInstalling optional Bayesian packages...\n")
  
  install_cran(bayesian_cran_packages)
  
} else {
  
  message(
    "\nSkipping optional Bayesian packages.",
    "\nUse --all to install them."
  )
  
}


# ------------------------------------------------------------
# 7. Check installations
# ------------------------------------------------------------

all_packages <- c(
  cran_packages,
  vapply(
    github_packages,
    function(repo) sub(".*/", "", repo),
    character(1)
  )
)

if (install_all) {
  all_packages <- c(
    all_packages,
    bayesian_cran_packages
  )
}

package_status <- data.frame(
  package = all_packages,
  installed = vapply(
    all_packages,
    requireNamespace,
    quietly = TRUE,
    FUN.VALUE = logical(1)
  )
)

print(package_status)

if (any(!package_status$installed)) {
  warning("Some packages could not be installed.")
} else {
  message("\nAll requested packages are installed.")
}

message("\nPackage installation completed.")