
# ============================================================
# R Analysis Template
# Generate Simulated ERP Data
# ============================================================

# Load project setup
source("analysis/00_setup.R")

# Configuration
n_subjects <- 20
n_trials <- 20
sampling_rate <- 250

conditions <- c("control", "experimental")
channel <- "Pz"

time_ms <- seq(-200, 800, by = 1000 / sampling_rate)

# Create output directory
output_dir <- here::here("data", "example")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# Simulate participant-level variability
subject_effects <- rnorm(n_subjects, mean = 0, sd = 0.8)

# Generate data
erp_data <- vector("list", n_subjects * length(conditions))

counter <- 1

for (subject in seq_len(n_subjects)) {
  
  for (condition in conditions) {
    
    # P300 amplitude differs between conditions
    condition_amplitude <- if (condition == "experimental") {
      6
    } else {
      4.5
    }
    
    for (trial in seq_len(n_trials)) {
      
      # Trial-level amplitude variability
      trial_amplitude <- rnorm(1, mean = 0, sd = 1)
      
      # Simulated P300 response
      p300 <- (
        condition_amplitude +
          subject_effects[subject] +
          trial_amplitude
      ) * exp(
        -0.5 * ((time_ms - 350) / 65)^2
      )
      
      # Background activity and measurement noise
      background <- 0.5 * sin(2 * pi * time_ms / 180)
      
      noise <- rnorm(
        length(time_ms),
        mean = 0,
        sd = 2
      )
      
      amplitude <- p300 + background + noise
      
      erp_data[[counter]] <- data.frame(
        subject = sprintf("sub-%02d", subject),
        condition = condition,
        trial = trial,
        channel = channel,
        time_ms = time_ms,
        amplitude_uv = amplitude
      )
      
      counter <- counter + 1
    }
  }
}

# Combine trials
erp_data <- do.call(rbind, erp_data)

# Save dataset
output_file <- here::here(
  "data", "example", "erp_simulated.csv"
)

write.csv(
  erp_data,
  output_file,
  row.names = FALSE
)

message("Simulated ERP dataset created.")
message("Rows: ", nrow(erp_data))
message("Saved to: ", output_file)