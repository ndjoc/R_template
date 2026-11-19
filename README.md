# R Template

A reproducible R environment for data analysis, statistical modelling, and visualization using R and Pixi.

## Overview

A structured starting point for research projects, supporting data handling, statistical analysis, visualization, and reproducible workflows.

**Core tools:**
- **R:** Data analysis and visualization.
- **Pixi:** Environment and dependency management.
- **Git:** Version control.
- **CmdStanR and brms:** Optional Bayesian modelling.

## Project structure

```text
R_template/
├── analysis/       # Analysis scripts
├── R/              # Reusable functions
├── config/         # Configuration files
├── data/           # Input data (not tracked)
├── outputs/        # Figures, tables, and results
├── tests/          # Automated tests
├── pyproject.toml
├── pixi.lock
└── README.md
```

## Installation

**Requirements:** Git and Pixi. A separate R installation is not required.

```bash
git clone https://github.com/ndjoc/R_template.git
cd R_template

pixi install
pixi run install-packages
pixi run setup
```

For optional packages, including Bayesian modelling:

```bash
pixi run install-all-packages
```

## Environments

- **default:** Data analysis, frequentist statistics, and visualization.
- **bayes:** Extends the default environment with Bayesian modelling tools.

Install the Bayesian environment:

```bash
pixi install -e bayes
pixi run -e bayes install-brms
```

## Available commands

| Command | Description |
|---|---|
| `pixi install` | Install environment |
| `pixi run setup` | Load packages and project configuration |
| `pixi run install-packages` | Install additional R packages |
| `pixi run install-all-packages` | Install optional packages |
| `pixi run test` | Run automated tests |
| `pixi run session` | Display R session information |

## Configuration and paths

Project settings and file paths are defined centrally in `config/config.yaml`. This allows paths and analysis settings to be changed without modifying individual scripts.

Example configuration:

```yaml
project:
  name: "R_template"
  version: "0.1.0"

paths:
  data: "data"
  raw_data: "data/raw"
  processed_data: "data/processed"
  outputs: "outputs"
  figures: "outputs/figures"
  tables: "outputs/tables"
  reports: "reports"

visualization:
  figure_width: 8
  figure_height: 6
  figure_dpi: 300

reproducibility:
  random_seed: 1234
```

The configuration is loaded automatically by `analysis/00_setup.R`. To use it in an analysis script:

```r
source("analysis/00_setup.R")
```

Access configuration values using `$`:

```r
config$paths$figures
config$paths$tables
config$visualization$figure_dpi
```

### Saving outputs

Use `here::here()` to construct paths relative to the project root.

For example, save a figure:

```r
library(ggplot2)

p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

ggsave(
  filename = here::here(config$paths$figures, "scatterplot.png"),
  plot = p,
  width = config$visualization$figure_width,
  height = config$visualization$figure_height,
  dpi = config$visualization$figure_dpi
)
```

Or save a table:

```r
write.csv(
  mtcars,
  here::here(config$paths$tables, "mtcars.csv"),
  row.names = FALSE
)
```

Output directories are created automatically during project setup.

**Recommendation:** Define project paths and commonly changed settings in `config.yaml` rather than hardcoding them in analysis scripts. This keeps workflows portable and easier to maintain.

## Development

Store reusable functions in `R/`, organized by purpose (e.g. `data/`, `stats/`, `visualization/`, `utils/`). Keep individual analysis workflows in `analysis/`.

Use the project setup in analysis scripts:

```r
source("analysis/00_setup.R")
```

Load reusable functions when needed:

```r
source("R/data/read_data.R")
```

Add tests for important functions under `tests/testthat/` and run them with:

```bash
pixi run test
```

## Using RStudio

RStudio can be used to edit and manage project scripts. However, its R Console does not automatically use the Pixi environment.

To ensure that scripts run with the correct R version and installed packages, execute them through the RStudio Terminal using Pixi:

```bash
pixi run Rscript analysis/01_data_preparation.R
```

Run the project setup with:

```bash
pixi run setup
```

**Note:** Running scripts directly in the RStudio Console may use a separate system R installation rather than the Pixi-managed environment.

## Testing

Store tests in `tests/testthat/`, following the naming convention `test-<function-name>.R`.

Run all tests with:

```bash
pixi run test
```

## Reusable functions

Store reusable R functions in `R/`, organized by purpose (e.g. `data/`, `stats/`, `visualization/`, `utils/`). Source them in analysis scripts when needed:

```r
source("R/data/read_data.R")
```

## Reproducibility

Commit `pixi.lock` to Git to preserve the resolved environment dependencies. Use `config/config.yaml` for project settings and paths, and set random seeds for reproducible analyses.

Avoid committing raw data or temporary outputs unless required.
