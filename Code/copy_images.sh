#!/bin/bash

# Define paths
OUTPUT_DIR="_site"  # Adjust if using a different output directory
IMAGES_DIR="Images"

# Create the output directory for images if it doesn't exist
mkdir -p $OUTPUT_DIR/$IMAGES_DIR

# Copy images to the output directory
cp -r $IMAGES_DIR/* $OUTPUT_DIR/$IMAGES_DIR

echo "Images copied to $OUTPUT_DIR/$IMAGES_DIR"
