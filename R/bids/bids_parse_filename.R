
bids_parse_filename <- function(filename) {
  
  filename <- basename(filename)
  
  # Separate extension
  extension <- sub(
    "^.*?(\\.[^.]+(?:\\.gz)?)$",
    "\\1",
    filename,
    perl = TRUE
  )
  
  stem <- sub(
    "\\.[^.]+(?:\\.gz)?$",
    "",
    filename,
    perl = TRUE
  )
  
  # Split filename into components
  parts <- strsplit(stem, "_", fixed = TRUE)[[1]]
  
  # Extract entities
  entities <- parts[grepl("-", parts)]
  
  result <- list()
  
  for (entity in entities) {
    split_entity <- strsplit(entity, "-", fixed = TRUE)[[1]]
    
    key <- split_entity[1]
    value <- paste(split_entity[-1], collapse = "-")
    
    result[[key]] <- value
  }
  
  # Extract suffix (last component without a key-value pair)
  suffix <- parts[!grepl("-", parts)]
  
  if (length(suffix) > 0) {
    result$suffix <- suffix[length(suffix)]
  }
  
  result$extension <- extension
  
  return(result)
}