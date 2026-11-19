# R Template

A reproducible R environment for data analysis, statistical modelling, and visualization using R and Pixi.

## Overview

A structured starting point for research projects, supporting data handling, statistical analysis, visualization, and reproducible workflows.

**Core tools:**
- **R:** Data analysis and visualization.
- **Pixi:** Environment and dependency management.
- **Quarto:** Reproducible reports.
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
├── reports/        # Quarto reports
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
| `pixi run check` | Run development checks |
| `pixi run session` | Display R session information |
| `pixi run report` | Render Quarto reports |

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

## Reproducibility

Commit `pixi.lock` and project code to Git. Avoid committing raw datasets, temporary files, or generated outputs unless explicitly required.

## License

To be specified.