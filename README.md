# docker-placeholder

This is SFO Museum's Dockerfile for running the (Pelias) Placeholder service.

This creates a container image with the [Placeholder](https://github.com/pelias/placeholder/) software and the SQLite database it uses stored locally (to the container). That means it creates a container image that is _very very_ big. This may not be the container image you want to use. We may not use it, in time.

## Fetching the data

You can either fetch the data yourself from https://s3.amazonaws.com/pelias-data.nextzen.org/placeholder/store.sqlite3.gz or util the handy `make data` target in the Makefile (which in turn runs the [utils/fetch-data.sh](utils/fetch-data.sh) script.

## Building

Just run the following:

```
docker build -t placeholder .
```

This assumes you've already fetched the data (see above) and it is stored in the same directory as the `Dockerfile`. I guess we could move the fetching of the data in the `Dockerfile` itself. That's not what we do, today.

## Running

### Locally

```
> make start
docker run -it -p 3000:3000 placeholder npm start --prefix /usr/local/pelias/placeholder

> pelias-placeholder@0.0.0-development start /usr/local/pelias/placeholder
> ./cmd/server.sh

2019-08-26T18:38:06.718Z - info: [placeholder] [master] using 2 cpus
2019-08-26T18:38:06.761Z - info: [placeholder] [master] worker forked 24
2019-08-26T18:38:06.763Z - info: [placeholder] [master] worker forked 25
2019-08-26T18:38:07.515Z - info: [placeholder] [worker 24] listening on 0.0.0.0:3000
2019-08-26T18:38:07.515Z - info: [placeholder] [worker 25] listening on 0.0.0.0:3000
```

## See also

* https://geocode.earth/blog/2019/almost-one-line-coarse-geocoding
* https://github.com/pelias/placeholder/