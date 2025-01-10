version: '3.8'

services:
  flask:
    build:
      context: .
    container_name: flask-app
    ports:
      - "5000:5000"  # Map Flask to port 5000
    depends_on:
      - mongodb  # Ensure MongoDB starts before Flask

  mongodb:
    image: mongo:latest
    container_name: mongodb
    ports:
      - "27017:27017"  # Expose MongoDB on port 27017
    volumes:
      - mongo-data:/data/db  # Persist MongoDB data
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin  # Set MongoDB admin username
      MONGO_INITDB_ROOT_PASSWORD: password  # Set MongoDB admin password

volumes:
  mongo-data:
