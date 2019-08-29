docker:
	docker build -t placeholder .

data:
	sh ./utils/fetch-data.sh

start:
	docker run -it -p 3000:3000 placeholder npm start --prefix /usr/local/pelias/placeholder
