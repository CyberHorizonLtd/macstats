rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r requirements.txt
open http://127.0.0.1:4637/storage
python3 backend.py
