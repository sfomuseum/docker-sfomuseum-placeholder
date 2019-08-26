# docker-placeholder

This is SFO Museum's Dockerfile for running the (Pelias) Placeholder service.

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