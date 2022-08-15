docker:
	docker build -t sfomuseum-placeholder .

docker-nocache:
	docker build --no-cache=true -t sfomuseum-placeholder .

# curl -s -I https://data.geocode.earth/placeholder/store.sqlite3.gz | grep etag
# curl -s -I https://data.geocode.earth/placeholder/store.sqlite3.gz | grep etag > store.sqlite3.gz.etag 
# curl -s -o data/store.sqlite3.gz https://data.geocode.earth/placeholder/store.sqlite3.gz

start:
	docker run -it -p 8080:8080 sfomuseum-placeholder
