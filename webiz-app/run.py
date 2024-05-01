#!/usr/bin/env python
import json
import logging
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

@app.route("/")
def root_handler():
    text = read_text_from_json('data.json')
    html_content = f"""
    <html>
        <head>
            <style>
                html, body {{
                    height: 100%;
                    margin: 0;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-direction: column;
                }}
            </style>
        </head>
        <body>
            <h1>{text}</h1>
            <h1 id="clock"></h1>
            <script>
                function updateTime() {{
                    var now = new Date();
                    var hours = now.getUTCHours() + 4; // Tbilisi is GMT+4
                    if (hours > 23) hours -= 24; // Handle UTC day overflow
                    var minutes = now.getUTCMinutes();
                    var seconds = now.getUTCSeconds();
                    document.getElementById('clock').textContent = 
                        (hours < 10 ? '0' : '') + hours + ':' +
                        (minutes < 10 ? '0' : '') + minutes + ':' +
                        (seconds < 10 ? '0' : '') + seconds;
                }}
                setInterval(updateTime, 1000);
                updateTime();
            </script>
        </body>
    </html>
    """
    return html_content

@app.route("/health_check")
def health_check_handler():
    return jsonify({"status": "ok"}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)