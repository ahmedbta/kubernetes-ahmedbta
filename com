version: '3.8'

services:
  flask:
    build:
      context: .  # Build Flask app from the Dockerfile in the current directory
    container_name: flask-app
    ports:
      - "5000:5000"  # Expose Flask app on port 5000
    depends_on:
      - mongodb  # Ensure MongoDB starts before Flask
    networks:
      - flask-mongo-network

  mongodb:
    image: mongo:latest  # Use the official MongoDB image
    container_name: mongodb
    ports:
      - "27017:27017"  # Expose MongoDB on port 27017
    volumes:
      - mongo-data:/data/db  # Persist MongoDB data
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin  # MongoDB admin username
      MONGO_INITDB_ROOT_PASSWORD: password  # MongoDB admin password
    networks:
      - flask-mongo-network

volumes:
  mongo-data:

networks:
  flask-mongo-network:
