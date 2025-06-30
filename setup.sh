#!/bin/bash
set -e

notify() {
  # usage: notify "Title" "Message"
  osascript -e "display notification \"$2\" with title \"$1\""
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Homebrew installation check
if ! command_exists brew; then
  notify "Installer" "Homebrew not found, installing now..."
  echo "Homebrew not found. Installing Homebrew non-interactively..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for this shell session
  if [ -d "/opt/homebrew/bin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -d "/usr/local/bin" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    notify "Installer" "Homebrew installation failed. Please add it to your PATH manually."
    echo "Cannot find Homebrew after installation, please add it to your PATH manually."
    exit 1
  fi
  notify "Installer" "Homebrew installed successfully."
else
  notify "Installer" "Homebrew is already installed."
fi

# Python3 check
if ! command_exists python3; then
  notify "Installer" "Python3 not found, installing now..."
  echo "Installing Python3 via Homebrew..."
  brew install python
  notify "Installer" "Python3 installed successfully."
else
  notify "Installer" "Python3 already installed."
fi

# pip3 check
if ! command_exists pip3; then
  notify "Installer" "pip3 missing, installing now..."
  echo "pip3 missing, installing via ensurepip..."
  python3 -m ensurepip --upgrade || {
    notify "Installer" "Failed to install pip3, exiting."
    echo "Failed to install pip3, exiting."
    exit 1
  }
  notify "Installer" "pip3 installed successfully."
else
  notify "Installer" "pip3 already installed."
fi

notify "Installer" "Cleaning up old files..."

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

# Remove old files
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "Removing $file..."
    rm "$file"
  fi
done

# Remove old templates
for template in "${templates[@]}"; do
  if [ -f "${templateextension}${template}" ]; then
    echo "Removing ${templateextension}${template}..."
    rm "${templateextension}${template}"
  fi
done

notify "Installer" "Downloading files..."

# Download files
for file in "${files[@]}"; do
  echo "Downloading $file..."
  curl -s -O "${baseurl}${file}"
done

# Download templates (make sure directory exists)
for template in "${templates[@]}"; do
  echo "Downloading ${templateextension}${template}..."
  mkdir -p "$(dirname "${templateextension}${template}")"
  curl -s -o "${templateextension}${template}" "${baseurl}${templateextension}${template}"
done

notify "Installer" "Running run.sh script..."
bash run.sh
notify "Installer" "run.sh script finished."
