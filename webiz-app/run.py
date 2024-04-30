#!/usr/bin/env python
import json
import logging
from datetime import datetime, timedelta
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(level=logging.INFO)  # Set the logging level as per your requirement
logger = logging.getLogger(__name__)

# Function to read text from JSON file
def read_text_from_json(filename):
    with open(filename, 'r') as file:
        data = json.load(file)
    return data['text']

# Function to get current time in Tbilisi timezone (GMT+4)
def get_tbilisi_time():
    tbilisi_time = datetime.utcnow() + timedelta(hours=4)
    return tbilisi_time.strftime("%Y-%m-%d %H:%M:%S")

@app.route("/")
def root_handler():
    text = read_text_from_json('data.json')
    tbilisi_time = get_tbilisi_time()
    final_text = f"{text} {tbilisi_time}"
    return final_text

@app.route("/health_check")
def health_check_handler():
    return jsonify({"status": "ok"}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)