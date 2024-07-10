#!/bin/bash

# Fetch the list of changed Java files
CHANGED_FILES=$(git diff --name-only --diff-filter=d HEAD^ | grep '\.java$')

if [ -z "$CHANGED_FILES" ]; then
  echo "No Java files changed"
  exit 0
fi

# Download Google Java Format
curl -LJO https://github.com/google/google-java-format/releases/download/v1.22.0/google-java-format-1.22.0-all-deps.jar

# Format each changed Java file using AOSP style (4-space indentation)
for FILE in $CHANGED_FILES; do
  java -jar google-java-format-1.22.0-all-deps.jar --aosp --replace "$FILE"
done

# Check if there are any changes to commit
if [ -n "$(git status --porcelain)" ]; then
  echo "Formatting changes made"
  exit 0
else
  echo "No formatting changes necessary"
  exit 0
fi
