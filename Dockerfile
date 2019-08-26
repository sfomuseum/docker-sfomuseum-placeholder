FROM ubuntu:latest

RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get install -y gcc g++ make git curl sqlite3 \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && mkdir -p /usr/local/pelias \
    && cd /usr/local/pelias \
    && git clone https://github.com/pelias/placeholder.git \
    && cd placeholder \
    && npm install \
    && mkdir -p /usr/local/pelias/placeholder/data
    
COPY store.sqlite3 /usr/local/pelias/placeholder/data/