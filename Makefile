docker:
	docker build -t placeholder .

data:
	wget https://s3.amazonaws.com/pelias-data.nextzen.org/placeholder/store.sqlite3.gz
	gunzip store.sqlite3.gz

start:
	docker run -it -p 3000:3000 placeholder npm start --prefix /usr/local/pelias/placeholder
