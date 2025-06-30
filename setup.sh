baseurl="https://raw.githubusercontent.com/CyberHorizonLtd/macstats/refs/heads/main/"
files=(
    "templates/pages/storage.html"
    "backend.py"
    "requirements.txt"
    "run.sh"
)

for file in "${files[@]}"; do
    echo "Downloading $file..."
    curl -O "${baseurl}${file}"
done

bash run.sh