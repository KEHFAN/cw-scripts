#!/bin/bash

#mvn -v

traverseDir() {
  for file in "$1"/*; do
    if [ -d "$file" ]; then
      echo "directory: $file"
      traverseDir "$file"
    elif [ -f "$file" ]; then
      echo "File: $file"
    fi
  done
}

traverseDir .