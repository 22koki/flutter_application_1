#!/bin/bash

counter=85

for file in *.jpg; do
    # Check if the file name doesn't match the desired format
    if [[ ! "$file" =~ ^image[0-9]+\.jpg$ ]]; then
        new_name="image$(printf "%02d" $counter).jpg"
        mv "$file" "$new_name"
        ((counter++))
    fi
done
