from flask import Flask, request
from pymongo import MongoClient
import socket
from datetime import datetime

# Flask app setup
app = Flask(__name__)

# MongoDB connection
client = MongoClient("mongodb://mongodb:27017/")  # Use the Docker service name as hostname
db = client["challenge3db"]  # Database name
collection = db["requests"]  # Collection name

@app.route("/")
def homepage():
    # Record client IP and date
    client_ip = request.remote_addr
    current_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    collection.insert_one({"ip": client_ip, "date": current_date})
    
    # Retrieve the last 10 records
    records = collection.find().sort("_id", -1).limit(10)
    records_html = "".join([f"<li>{r['ip']} - {r['date']}</li>" for r in records])
    
    # Server details
    server_name = socket.gethostname()
    
    return f"""
    <html>
        <body>
            <h1>Flask Docker App</h1>
            <p>Your Name: [Your Name]</p>
            <p>Project Name: Flask App + MongoDB</p>
            <p>Version: V2</p>
            <p>Server Hostname: {server_name}</p>
            <p>Current Date: {current_date}</p>
            <h2>Last 10 Requests:</h2>
            <ul>{records_html}</ul>
        </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
