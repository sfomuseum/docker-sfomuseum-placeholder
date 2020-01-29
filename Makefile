docker:
	docker build -t placeholder .

# curl -s -I https://data.geocode.earth/placeholder/store.sqlite3.gz | grep etag
# curl -s -I https://data.geocode.earth/placeholder/store.sqlite3.gz | grep etag > store.sqlite3.gz.etag 
# curl -s -o store.sqlite3.gz https://data.geocode.earth/placeholder/store.sqlite3.gz

data:
	sh ./utils/fetch-data.sh

start:
	docker run -it -p 3000:3000 placeholder npm start --prefix /usr/local/pelias/placeholder
