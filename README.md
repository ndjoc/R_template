# R Research Template

A reproducible, modular R environment for research data analysis, statistical modelling, and visualization, managed with [Pixi](https://pixi.sh/), Git, and Quarto.

## Features

- Reproducible, cross-platform R environment (R 4.4.x)
- Data management and visualization with tidyverse and data.table
- Statistical modelling, including mixed-effects and Bayesian models
- Reusable functions and configurable project structure
- Data validation and automated testing with testthat
- Quarto-based HTML reporting
- Optional Bayesian environment with brms and CmdStan

## Project structure

```text
R_template/
├── analysis/       # Analysis and workflow scripts
├── R/              # Reusable functions
│   ├── data/
│   ├── stats/
│   ├── visualization/
│   ├── utils/
│   └── bids/
├── config/         # Project configuration
├── data/           # Raw, processed, and example data
├── outputs/        # Figures, tables, and reports
├── reports/        # Quarto report sources
├── tests/          # Automated tests
├── pyproject.toml  # Pixi configuration and tasks
├── pixi.lock       # Locked Pixi dependencies
└── README.md
```

## Getting started

**Requirements:** [Git](https://git-scm.com/) and [Pixi](https://pixi.sh/).

Click the **Use this template** button on the top right. You can name your own repository with the template as you need and then clone it. 
```bash
cd R_template

pixi install
pixi run setup
pixi run install-packages
```

The setup task loads `config/config.yaml`, initializes the project, sets the random seed, and creates output directories. Additional CRAN and GitHub packages are installed separately through `R/00_install_packages.R`.

## Workflow

The template separates data generation, analysis, reusable functions, and reporting.

1. **Data:** Organize raw, processed, and example data under `data/`.
2. **Analysis:** Develop workflows and analysis scripts in `analysis/`.
3. **Functions:** Store reusable code in the appropriate `R/` subdirectories.
4. **Validation:** Check input data, analysis results, and generated outputs.
5. **Reporting:** Create Quarto documents in `reports/` and render HTML reports to `outputs/reports/`.

An example ERP workflow demonstrates data generation, validation, statistical summaries, visualization, and reporting.

Run the example workflow:

```bash
pixi run Rscript analysis/01_generate_example_data.R
pixi run Rscript analysis/02_example_analysis.R
pixi run report
```

The analysis generates figures and tables in `outputs/`, which are then used by the Quarto report. Run the analysis before rendering the report.

## Testing and development

Automated tests use `testthat` and are stored in `tests/testthat/`.

```bash
pixi run test
```

Project settings, paths, visualization parameters, and reproducibility options are maintained in `config/config.yaml`. Use `here::here()` for project-relative paths.

Available Pixi tasks:

| Command | Purpose |
|---|---|
| `pixi run setup` | Initialize project |
| `pixi run session` | Display R session information |
| `pixi run install-packages` | Install additional packages |
| `pixi run test` | Run automated tests |
| `pixi run report` | Render example HTML report |

## Optional Bayesian environment

A separate environment provides `brms` and CmdStan:

```bash
pixi install -e bayes
pixi run -e bayes install-brms
pixi run -e bayes install-cmdstan
pixi run -e bayes check-cmdstan
```

## Reproducibility

- Commit `pyproject.toml` and `pixi.lock` to Git.
- Use configured random seeds.
- Keep analysis scripts, functions, and configuration under version control.
- Record package versions and R session information when appropriate.
- Avoid committing sensitive research data or temporary outputs.

Packages installed separately from CRAN or GitHub are not fully pinned by Pixi, so record their versions when exact reproducibility is required.

RStudio can be used for editing scripts and reports. Run analyses through the project terminal with `pixi run` to ensure the Pixi-managed R environment is used.