#!/bin/bash

baseurl="https://raw.githubusercontent.com/CyberHorizonLtd/macstats/refs/heads/main/"
files=(
    "backend.py"
    "requirements.txt"
    "run.sh"
)

#remove files
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Removing $file..."
        rm "$file"
    fi
done

templateextension="templates/pages/"
templates=(
    "storage.html"
)

#remove templates
for template in "${templates[@]}"; do
    if [ -f "${templateextension}${template}" ]; then
        echo "Removing ${templateextension}${template}..."
        rm "${templateextension}${template}"
    fi
done

for file in "${files[@]}"; do
    echo "Downloading $file..."
    curl -O "${baseurl}${file}"
done
for template in "${templates[@]}"; do
    #download baseurl+templateextension+template
    #save to templateextension+template
    echo "Downloading ${templateextension}${template}..."
    curl -o "${templateextension}${template}" "${baseurl}${templateextension}${template}"
done

bash run.sh