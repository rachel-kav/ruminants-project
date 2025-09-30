#!/usr/bin/env Rscript

# Load arguments from command line
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Usage: Rscript phylip.R input_file output_file")
}

input_file <- args[1]
output_file <- args[2]

# Define function to read dN/dS matrix
read_dNdS <- function(file) {
  lines <- readLines(file)
  ntaxa <- as.integer(lines[1])
  taxa <- character(ntaxa)
  mat <- matrix(0, nrow = ntaxa, ncol = ntaxa)
  
  for (i in 1:ntaxa) {
    tokens <- strsplit(lines[i + 1], "\\s+")[[1]]
    tokens <- tokens[tokens != ""]
    taxa[i] <- tokens[1]
    
    if (length(tokens) > 1) {
      mat[i, 1:(length(tokens) - 1)] <- as.numeric(tokens[-1])
    }
  }
  mat <- mat + t(mat)
  rownames(mat) <- taxa
  colnames(mat) <- taxa
  
  return(mat)
}

# Define function to remove unwanted species
remove_species <- function(mat, species_to_remove) {
  valid_species <- species_to_remove[species_to_remove %in% rownames(mat)]
  mat_clean <- mat[!(rownames(mat) %in% valid_species), !(colnames(mat) %in% valid_species)]
  return(mat_clean)
}

# Customize the species you want to remove
species_to_remove <- c("ForestMuskDeer2", "Camel")

# Process the file
mat <- read_dNdS(input_file)
threshold <- 4.5
mat[mat >= threshold] <- threshold - 0.01
mat[is.na(mat)] <- threshold - 0.01
mat[is.infinite(mat)] <- threshold - 0.01

mat_clean <- remove_species(mat, species_to_remove)

# Save cleaned matrix to .rds
saveRDS(mat_clean, file = output_file)

