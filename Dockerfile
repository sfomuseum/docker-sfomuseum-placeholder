FROM ubuntu:latest

RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get install -y gcc g++ make git curl sqlite3 wget supervisor nodejs npm \

    && mkdir /build \
    && cd /build \

    # Install Go from source
    
    && wget https://golang.org/dl/go1.19.linux-amd64.tar.gz \
    && tar -xvzf go1.19.linux-amd64.tar.gz \
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

    # Install Placeholder
    
    && mkdir -p /usr/local/pelias \
    && cd /usr/local/pelias \
    && git clone https://github.com/pelias/placeholder.git \
    && cd placeholder \
    && npm install \
    && mkdir -p /usr/local/pelias/placeholder/data

# Setup supervisord stuff

RUN mkdir -p /etc/supervisord.d
RUN mkdir -p /var/log/placeholder/

RUN echo  '[supervisord] \n\
[unix_http_server] \n\
file = /tmp/supervisor.sock \n\
chmod = 0777 \n\
chown= nobody:nogroup \n\
[supervisord] \n\
logfile = /tmp/supervisord.log \n\
logfile_maxbytes = 50MB \n\
logfile_backups=10 \n\
loglevel = info \n\ 
pidfile = /tmp/supervisord.pid \n\
nodaemon = true \n\
umask = 022 \n\
identifier = supervisor \n\
[supervisorctl] \n\
serverurl = unix:///tmp/supervisor.sock \n\
[rpcinterface:supervisor] \n\
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface \n\
[include] \n\
files = /etc/supervisord.d/*.conf' >> /etc/supervisord.conf

# stdout_logfile=/var/log/placeholder/stdout.log \n\
# stdout_logfile_maxbytes=0MB \n\ 
# stderr_logfile=/var/log/placeholder/stderr.log \n\
# stderr_logfile_maxbytes=10MB \n\

RUN echo '[placeholder] \n\
nodaemon=true \n\
[program:placeholder] \n\
command=/usr/bin/npm start --prefix /usr/local/pelias/placeholder \n\
autostart=true \n\
autorestart=true \n\
exitcodes=0 ' >> /etc/supervisord.d/placeholder.conf

RUN echo '[placeholder-www] \n\
nodaemon=true \n\
[program:placeholder-www] \n\
command=/usr/local/bin/placeholder-www -server-uri http://0.0.0.0:8080 -nextzen-apikey xxxxxx -api -prefix /places\n\
autorestart=unexpected \n\
stdout_logfile=/dev/fd/1 \n\
stdout_logfile_maxbytes=0MB \n\
stderr_logfile_maxbytes = 0 \n\
stderr_logfile=/dev/fd/2 \n\
redirect_stderr=true \n\
exitcodes=0 ' >> /etc/supervisord.d/placeholder-www.conf

COPY data/store.sqlite3 /usr/local/pelias/placeholder/data/

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]