#!/bin/bash

# Input folder with RDS files
INPUT_DIR="/Users/qjs599/Desktop/ruminants/ruminants_project/data/ds_trees"

# Base output folder
BASE_OUT_DIR="/Users/qjs599/Desktop/ruminants/ruminants_project/data/ds_mat"

# Path to your R script that does the conversion
R_SCRIPT="/Users/qjs599/Desktop/ruminants/ruminants_project/scripts/dnds_pml/phylip_script.R"

# Loop through each RDS file
for RDS_FILE in "$INPUT_DIR"/*.rds; do
  BASENAME=$(basename "$RDS_FILE" .rds)
  OUT_DIR="$BASE_OUT_DIR/$BASENAME"
  OUT_FILE="$OUT_DIR/ds_mat.txt"
  
  if [ -f "$RDS_FILE" ]; then
    echo "Processing $RDS_FILE → $OUT_FILE"
    mkdir -p "$OUT_DIR"
    Rscript "$R_SCRIPT" "$RDS_FILE" "$OUT_FILE"
  else
    echo "No RDS file found at $RDS_FILE"
  fi
done

