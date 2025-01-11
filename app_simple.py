from flask import Flask
import socket
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def homepage():
    server_name = socket.gethostname()
    current_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return f"""
    <html>
        <body>
            <h1>Flask Simple App</h1>
            <p>Server Hostname: {server_name}</p>
            <p>Current Date: {current_date}</p>
        </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
