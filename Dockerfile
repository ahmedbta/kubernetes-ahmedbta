<<<<<<< HEAD
FROM python:3.8-slim
WORKDIR /KuberByBTA
COPY . /KuberByBTA
RUN pip install Flask
EXPOSE 5000
=======
FROM python:3.9-slim
WORKDIR /app
COPY . /app
RUN pip install flask pymongo
>>>>>>> 7857b13 ( challenge4 update?)
CMD ["python", "app.py"]

