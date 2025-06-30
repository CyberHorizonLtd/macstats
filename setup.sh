#!/bin/bash
set -e

notify() {
  # usage: notify "Title" "Message"
  osascript -e "display notification \"$2\" with title \"$1\""
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not installed (completely non-interactive)
if ! command_exists brew; then
    notify "Homebrew Installation" "Please install Homebrew to continue."
    exit 0
fi

# Install Python3 if missing
if ! command_exists python3; then
    echo "Installing Python3 via Homebrew..."
    brew install python
else
    echo "Python3 already installed."
fi

# Check pip3
if ! command_exists pip3; then
    echo "pip3 missing, installing via ensurepip..."
    python3 -m ensurepip --upgrade || {
        echo "Failed to install pip3, exiting."
        exit 1
    }
else
    echo "pip3 already installed."
fi

# Your script variables and arrays
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

# Remove existing files
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Removing $file..."
        rm "$file"
    fi
done

# Remove existing templates
for template in "${templates[@]}"; do
    if [ -f "${templateextension}${template}" ]; then
        echo "Removing ${templateextension}${template}..."
        rm "${templateextension}${template}"
    fi
done

# Download files
for file in "${files[@]}"; do
    echo "Downloading $file..."
    curl -s -O "${baseurl}${file}"
done

# Download templates
for template in "${templates[@]}"; do
    echo "Downloading ${templateextension}${template}..."
    mkdir -p "$(dirname "${templateextension}${template}")"
    curl -s -o "${templateextension}${template}" "${baseurl}${templateextension}${template}"
done

# Run your run.sh script
bash run.sh
