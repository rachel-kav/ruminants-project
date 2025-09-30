#!/bin/bash

# Set the base directory containing the subdirectories
BASE_DIR="/Users/qjs599/Desktop/ruminants/ruminants_project/data/dn_mat"

# Path to the species tree
TREE_FILE="/Users/qjs599/Desktop/ruminants/ruminants_project/data/stand_unroot_rumsptimetr.nwk"

# Loop through all subdirectories
for SUBDIR in "$BASE_DIR"/*/; do
  DN_MAT_FILE="${SUBDIR}dn_mat.txt"
  
  if [ -f "$DN_MAT_FILE" ]; then
    BASENAME=$(basename "$SUBDIR")
    OUTPUT_PATH="${SUBDIR}${BASENAME}_erable_dn_16.09"

    echo "Running erable on $DN_MAT_FILE → output in $SUBDIR"
    sed -i '' 's/[[:space:]]\{1,\}/ /g' "$DN_MAT_FILE"
    
    # Run erable with output going to the same subdirectory
    erable -i "$DN_MAT_FILE" -t "$TREE_FILE" -o "$OUTPUT_PATH"
  else
    echo "Skipping $SUBDIR: dn_mat.txt not found."
  fi
done

