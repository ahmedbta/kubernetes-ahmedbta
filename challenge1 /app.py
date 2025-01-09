from flask import Flask
import socket
import datetime

app = Flask(__name__)

@app.route("/")
def homepage():
    # Get current date
    current_date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    # Get server hostname
    hostname = socket.gethostname()

    # Replace with your own information
    name = "Ahmed Ben Taleb Ali"
    project_name = "Challenge 1"
    version = "V1"

    # Render all the details
    return f"""
    <h1>{project_name} - {version}</h1>
    <p>Developer: {name}</p>
    <p>Version: {version}</p>
    <p>Server Hostname: {hostname}</p>
    <p>Current Date: {current_date}</p>
    """

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
