#!/bin/bash

# ------------------------------------------------------------------------------
# This script handles the copying of image files from a local 'Images' directory
# to the Quarto rendered output directory (_site). It ensures that image files 
# are included in the final published site without exposing the 'Images' directory
# in the 'gh-pages' branch directly.
#
# Functionality includes:
#    1. Checking if the 'Images' directory exists.
#    2. Using 'rsync' to copy image files while preserving their directory structure.
#    3. Displaying messages to confirm the copying process.
#
# How to use:
#    1. Navigate to the project root directory in the Command-Line Application
#    2. Render the site using `quarto render`
#    3. Make this file executable `chmod +x Code/copy_images.sh`
#    4. Run the script `./Code/copy_images.sh`
#    5. Verify if the images were copied `ls -R _site`
#    6. Remove them if so `rm -rf _site/Images`
#    7. Publish using `quarto publish gh-pages --no-render`
#
# Author: Shelby Golden, M.S.
#   Date: Nov 2025
#
# Note: Written with the assistance of Yale's AI, Clarity.
# ------------------------------------------------------------------------------


# Define paths
OUTPUT_DIR="_site"
IMAGES_DIR="Images"

# Check if the Images directory exists
if [ -d "$IMAGES_DIR" ]; then
  # Use rsync to copy image files while preserving directory structure
  rsync -av --include='*/' --include='*.png' --include='*.jpg' --include='*.jpeg' --include='*.gif' --include='*.svg' --exclude='*' $IMAGES_DIR/ $OUTPUT_DIR/$IMAGES_DIR/
  echo "Images copied to $OUTPUT_DIR/$IMAGES_DIR"
else
  echo "Images directory not found"
fi