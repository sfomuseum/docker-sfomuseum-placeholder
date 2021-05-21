docker:
	docker build -t placeholder .

docker-nocache:
	docker build --no-cache=true -t placeholder .

# curl -s -I https://data.geocode.earth/placeholder/store.sqlite3.gz | grep etag
# curl -s -I https://data.geocode.earth/placeholder/store.sqlite3.gz | grep etag > store.sqlite3.gz.etag 
# curl -s -o store.sqlite3.gz https://data.geocode.earth/placeholder/store.sqlite3.gz

data:
	sh ./utils/fetch-data.sh

start:
	docker run -it -p 8080:8080 placeholder
