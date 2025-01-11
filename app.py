<<<<<<< HEAD
from flask import Flask
import socket
import datetime

app = Flask(__name__)

@app.route("/")
def homepage():

    current_date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    hostname = socket.gethostname()


    name = "Ahmed Ben Taleb Ali"
    project_name = "Challenge 1"
    version = "V1"


    return f"""
    <h1>{project_name} - {version}</h1>
    <p>Developer: {name}</p>
    <p>Version: {version}</p>
    <p>Server Hostname: {hostname}</p>
    <p>Current Date: {current_date}</p>
    """

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
=======
from flask import Flask, request
from pymongo import MongoClient
import socket
from datetime import datetime


app = Flask(__name__)

client = MongoClient("mongodb://admin:password@mongodb:27017/")  
db = client["challenge3db"] 
collection = db["requests"]  

@app.route("/")
def homepage():
    
    client_ip = request.remote_addr
    current_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    collection.insert_one({"ip": client_ip, "date": current_date})
    

    records = collection.find().sort("_id", -1).limit(10)
    records_html = "".join([f"<li>{r['ip']} - {r['date']}</li>" for r in records])
    

    server_name = socket.gethostname()
    
    return f"""
    <html>
        <body>
            <h1>Flask Docker App</h1>
            <p>Your Name: Ahmed Ben Taleb Ali</p>
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

>>>>>>> 7857b13 ( challenge4 update?)
