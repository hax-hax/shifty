#!/usr/bin/env bash -e
source "$(dirname "$0")/_common.sh"

# Target directory
target_directory="/path/to/target/directory"

# Threshold in 1 KB blocks (1.0TB)
threshold_kb=1000000000

# Get the total size of the target directory in 1 KB blocks
total_size_kb=$(du -s "$target_directory" | cut -f1)

# Compare the total size with the threshold
while (( total_size_kb > threshold_kb )); do
    # Find leaf directories (those without subdirectories)
    dir_to_delete=$(find "$target_directory"/* -type d -links 2 -print | xargs du -s | sort -n | head -n 1 | cut -f2)

    # Delete the identified directory
    echo rm -rf "$dir_to_delete"

    # Recalculate total size
    total_size_kb=$(du -s "$target_directory" | cut -f1)
done

echo "Total size is now below 1TB."
