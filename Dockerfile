# https://github.com/pelias/docker-baseimage/blob/master/Dockerfile
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y jq lbzip2 parallel git wget && rm -rf /var/lib/apt/lists/*

# Install Go from source
    
RUN mkdir -p /usr/local/src && cd /usr/local/src \
    && wget https://golang.org/dl/go1.19.linux-amd64.tar.gz \
    && tar -xvzf go1.19.linux-amd64.tar.gz \
    && mv go /usr/local/go \
    && ln -s /usr/local/go/bin/* /usr/local/bin/ \
    && cd / && rm -rf /usr/local/src

# Install go-placeholder-client-www

RUN mkdir -p /build \
    && git clone https://github.com/sfomuseum/go-placeholder-client-www.git /build/go-placeholder-client-www \
    && cd /build/go-placeholder-client-www \
    && /usr/local/bin/go build -mod vendor -o /usr/local/bin/placeholder-www cmd/server/main.go \
    && cd / && rm -rf /build

# Install placeholder

RUN mkdir -p /code/pelias/

RUN git clone https://github.com/pelias/placeholder.git /code/pelias/placeholder \
    && cd /code/pelias/placeholder \
    && npm install

RUN mkdir -p /data/placeholder
RUN chown pelias /data/placeholder

COPY bin/placeholder /usr/local/bin/placeholder

ENV PLACEHOLDER_DATA '/data/placeholder'
USER pelias

CMD [ "/usr/local/bin/placeholder" ]
