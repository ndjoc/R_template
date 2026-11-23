
# ============================================================
# R Analysis Template
# Example ERP Analysis
# ============================================================


# 1. Project setup

source("analysis/00_setup.R")


# 2. Load data

data_file <- here::here(
  "data", "example", "erp_simulated.csv"
)

if (!file.exists(data_file)) {
  stop(
    "Example dataset not found. Run ",
    "analysis/01_generate_example_data.R first."
  )
}

erp_data <- read.csv(data_file)

message("Loaded ERP dataset: ", nrow(erp_data), " observations")


# 3. Validate input data

source(
  here::here("R", "utils", "validate_erp_data.R")
)

validate_erp_data(erp_data)


# 4. Calculate participant-level averages

library(dplyr)
library(ggplot2)

subject_averages <- erp_data %>%
  group_by(subject, condition, time_ms) %>%
  summarise(
    mean_amplitude = mean(amplitude_uv, na.rm = TRUE),
    .groups = "drop"
  )


# 5. Calculate grand averages and standard errors

erp_summary <- subject_averages %>%
  group_by(condition, time_ms) %>%
  summarise(
    grand_mean = mean(mean_amplitude, na.rm = TRUE),
    sd_amplitude = stats::sd(mean_amplitude, na.rm = TRUE),
    n_subjects = n(),
    .groups = "drop"
  ) %>%
  mutate(
    se_amplitude = sd_amplitude / sqrt(n_subjects)
  ) %>%
  rename(
    mean_amplitude = grand_mean
  )


# 6. Validate analysis results

expected_subjects <- dplyr::n_distinct(erp_data$subject)

if (!all(erp_summary$n_subjects == expected_subjects)) {
  stop("Unexpected participant count in ERP summary.")
}

if (
  any(!is.finite(erp_summary$mean_amplitude)) ||
  any(!is.finite(erp_summary$sd_amplitude)) ||
  any(!is.finite(erp_summary$se_amplitude))
) {
  stop("Non-finite values found in ERP summary.")
}

message("Analysis result validation passed.")


# 7. Create ERP plot

erp_plot <- ggplot(
  erp_summary,
  aes(
    x = time_ms,
    y = mean_amplitude,
    colour = condition,
    fill = condition
  )
) +
  geom_ribbon(
    aes(
      ymin = mean_amplitude - se_amplitude,
      ymax = mean_amplitude + se_amplitude
    ),
    alpha = 0.2,
    colour = NA
  ) +
  geom_line(linewidth = 1) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed",
    colour = "grey50"
  ) +
  geom_vline(
    xintercept = 0,
    linetype = "dashed",
    colour = "grey50"
  ) +
  labs(
    title = "Simulated ERP Responses",
    subtitle = "Grand average across participants",
    x = "Time relative to stimulus onset (ms)",
    y = expression("Amplitude (" * mu * "V)"),
    colour = "Condition",
    fill = "Condition"
  ) +
  theme_minimal(
    base_size = config$visualization$base_size
  ) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold")
  )


# 8. Save figure

figure_file <- here::here(
  config$paths$figures,
  "erp_grand_average.png"
)

ggsave(
  filename = figure_file,
  plot = erp_plot,
  width = config$visualization$figure_width,
  height = config$visualization$figure_height,
  dpi = config$visualization$figure_dpi
)


# 9. Save summary data

summary_file <- here::here(
  config$paths$tables,
  "erp_summary.csv"
)

write.csv(
  erp_summary,
  summary_file,
  row.names = FALSE
)


# 10. Validate output files

if (
  !file.exists(figure_file) ||
  file.info(figure_file)$size == 0
) {
  stop("ERP figure was not saved correctly.")
}

if (
  !file.exists(summary_file) ||
  file.info(summary_file)$size == 0
) {
  stop("ERP summary was not saved correctly.")
}

message("Output validation passed.")


# 11. Report results

message("\nERP analysis completed.")
message("Participants: ", expected_subjects)
message("Conditions: ", dplyr::n_distinct(erp_data$condition))
message("Time points: ", dplyr::n_distinct(erp_data$time_ms))
message("Figure saved to: ", figure_file)
message("Summary saved to: ", summary_file)
