#!/bin/bash

baseurl="https://raw.githubusercontent.com/CyberHorizonLtd/macstats/refs/heads/main/"
files=(
    "backend.py"
    "requirements.txt"
    "run.sh"
)
templateextension="templates/pages/"
templates=(
    "storage.html"
)
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