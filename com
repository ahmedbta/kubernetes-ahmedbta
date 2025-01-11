docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' flask-app-db
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' flask-app-simple
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mongodb
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx
