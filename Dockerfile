FROM ubuntu:latest

RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get install -y gcc g++ make git curl sqlite3 wget \

    && mkdir /build \
    && cd /build \

    # Install Go from source
    
    && wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz \
    && tar -xvzf go1.16.4.linux-amd64.tar.gz \
    # && mv go /usr/local \
    # && ln -s /usr/local/go/bin/* /usr/local/bin/ \
    # && cd - \

    # Install go-placeholder-client-www 

    && git clone https://github.com/sfomuseum/go-placeholder-client-www.git \
    && cd /build/go-placeholder-client-www \
    && /build/go/bin/go build -mod vendor -o /usr/local/bin/placeholder-www cmd/server/main.go \
    && cd / \

    # Clean up
    
    && rm -rf /build \

#    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
#    && apt-get install -y nodejs \
    
#    && mkdir -p /usr/local/pelias \
#    && cd /usr/local/pelias \
#    && git clone https://github.com/pelias/placeholder.git \
#    && cd placeholder \
#    && npm install \
#x    && mkdir -p /usr/local/pelias/placeholder/data
    
# COPY store.sqlite3 /usr/local/pelias/placeholder/data/