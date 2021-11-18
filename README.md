# docker-sfomuseum-placeholder

This is SFO Museum's Dockerfile for running the (Pelias) Placeholder service.

This creates a container image with the [Placeholder](https://github.com/pelias/placeholder/) software and the SQLite database it uses stored locally (to the container). That means it creates a container image that is _very very_ big. This may not be the container image you want to use. We may not use it, in time.

The container also contains a running instance of the [go-placeholder-client-www](https://github.com/sfomuseum/go-placeholder-client-www) server tool.

Both services are managed using the `supervisord` tool.

## Fetching the data

```
$> curl -s -o data/store.sqlite3.gz https://data.geocode.earth/placeholder/store.sqlite3.gz
$> gunzip data/store.sqlite3.gz
```

## Building

Just run the following:

```
$> docker build -t placeholder .
```

This assumes you've already fetched the data (see above) and it is stored in the same directory as the `Dockerfile`. I guess we could move the fetching of the data in the `Dockerfile` itself. That's not what we do, today.

## Running

Because the Placeholder service takes between 30-60 seconds to start up the `go-placeholder-client-www` application has its own internal "ready-check" to determine whether the Placeholder endpoint is accepting connections. While the Placeholder service is starting up the `go-placeholder-client-www` application will accept connections but its search functionality is disabled.

### Locally

```
$> docker run -it -p 8080:8080 -e PLACEHOLDER_NEXTZEN_APIKEY=**** placeholder

2021-05-21 20:00:01,086 INFO Included extra file "/etc/supervisord.d/placeholder-www.conf" during parsing
2021-05-21 20:00:01,086 INFO Included extra file "/etc/supervisord.d/placeholder.conf" during parsing
2021-05-21 20:00:01,099 INFO RPC interface 'supervisor' initialized
2021-05-21 20:00:01,099 CRIT Server 'unix_http_server' running without any HTTP authentication checking
2021-05-21 20:00:01,100 INFO supervisord started with pid 1
2021-05-21 20:00:02,110 INFO spawned: 'placeholder' with pid 9
2021-05-21 20:00:02,118 INFO spawned: 'placeholder-www' with pid 10
2021/05/21 20:00:02 Listening on http://0.0.0.0:8080
2021-05-21 20:00:03,610 INFO success: placeholder entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2021-05-21 20:00:03,610 INFO success: placeholder-www entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2021/05/21 20:00:04 Check Placeholder status (http://localhost:3000)
2021/05/21 20:00:04 Failed to determine Placeholder status, Get "http://localhost:3000": dial tcp 127.0.0.1:3000: connect: connection refused
2021/05/21 20:00:06 Check Placeholder status (http://localhost:3000)
2021/05/21 20:00:06 Failed to determine Placeholder status, Get "http://localhost:3000": dial tcp 127.0.0.1:3000: connect: connection refused
2021/05/21 20:00:08 Check Placeholder status (http://localhost:3000)

...

2021/05/21 20:01:18 Failed to determine Placeholder status, Get "http://localhost:3000": dial tcp 127.0.0.1:3000: connect: connection refused
2021/05/21 20:01:20 Check Placeholder status (http://localhost:3000)
2021/05/21 20:01:20 Placeholder appears to running and accepting connections
```

## Deploy to AWS with the CDK

This project is setup to easily deploy and configure everything using AWS Elastic Container Service via the Cloud Development Kit (CDK). The end result is a working web application sitting behind an Elastic Load Balancer and running on EC2 Instances. (NOTE - We are using ECS with EC2 for now due to a limitation with Fargate having to do with networking.)

This project will use your existing VPC to deploy your ECS application. Please see the notes in [index.ts](index.ts) around Default VPCs and set the VPC_ID environment variable before deployment.

To deploy this way, do the following:

1. Edit your .env file with appropriate values
2. Configure your local environment with your AWS credentials
3. Follow these commands below

```
$ npm install -g aws-cdk
$ npm install
$ cdk bootstrap
$ cdk deploy
```

4. Wait - it will take some time to do its thing
5. You should end up with a DNS name for the Elastic Load Balancer where you can find your web app

To tear it all down you can do:

    $ cdk destroy

## See also

* https://geocode.earth/blog/2019/almost-one-line-coarse-geocoding
* https://millsfield.sfomuseum.org/blog/tags/placeholder
* https://github.com/pelias/placeholder/
* https://github.com/sfomuseum/go-placeholder-client-www
* https://github.com/sfomuseum/go-placeholder-client
