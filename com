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




FROM python:3.9-slim

WORKDIR /app

COPY . /app

RUN pip install flask pymongo

# Default command is app.py (can be overridden in docker-compose.yml)
CMD ["python", "app.py"]




version: '3.8'

services:
  flask-app-db:
    build:
      context: .
    container_name: flask-app-db
    environment:
      - FLASK_ENV=development
    ports:
      - "5001:5000"  # Map to a different port for debugging (optional)
    depends_on:
      - mongodb
    networks:
      - flask-network

  flask-app-simple:
    build:
      context: .
    container_name: flask-app-simple
    command: ["python", "app_simple.py"]  # Override CMD in Dockerfile
    environment:
      - FLASK_ENV=development
    ports:
      - "5002:5000"  # Map to a different port for debugging (optional)
    networks:
      - flask-network

  mongodb:
    image: mongo:latest
    container_name: mongodb
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db
    networks:
      - flask-network

  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"  # Expose NGINX on port 80
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf  # Bind custom NGINX config
    depends_on:
      - flask-app-db
      - flask-app-simple
    networks:
      - flask-network

volumes:
  mongo-data:

networks:
  flask-network:




events {}

http {
    upstream flask_backend {
        server flask-app-db:5000;
        server flask-app-simple:5000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://flask_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
