#!/bin/bash

# Define base and output directories
BASE_DIR="/Users/qjs599/Desktop/ruminants/ruminants_project/data/clean-paml-output-ruminants-23.07.25"
OUTPUT_DIR="/Users/qjs599/Desktop/ruminants/ruminants_project/data/clean_ds_trees"

mkdir -p "$OUTPUT_DIR"

# Iterate over subdirectories
for SUBDIR in "$BASE_DIR"/*/; do
  # Remove trailing slash and extract folder name
  FOLDER_NAME=$(basename "$SUBDIR")

  # Define input and output file paths
  INPUT_FILE="$SUBDIR/2ML.dS"
  OUTPUT_FILE="$OUTPUT_DIR/${FOLDER_NAME}.rds"

  # Check if input file exists
  if [ -f "$INPUT_FILE" ]; then
    echo "Processing $INPUT_FILE..."
    Rscript /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/dnds_pml/dist_mat_dnds.R "$INPUT_FILE" "$OUTPUT_FILE"
  else
    echo "Skipping $FOLDER_NAME: 2ML.dS not found."
  fi
done
