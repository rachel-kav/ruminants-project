#!/bin/bash

# Set base and output directories
BASE_DIR="/Users/qjs599/Desktop/ruminants/ruminants_project/data/ds_mat"
OUTPUT_DIR="/Users/qjs599/Desktop/ruminants/ruminants_project/data/ds_erable_output_16.09"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Find and copy matching files
find "$BASE_DIR" -type f -name "*erable_ds_16.09.length.nwk" ! -path "$OUTPUT_DIR/*" | while read -r filepath; do
    filename=$(basename "$filepath")

    cp "$filepath" "$OUTPUT_DIR/$filename"
    echo "Copied $filepath to $OUTPUT_DIR/$newname"
done

echo "Done."

