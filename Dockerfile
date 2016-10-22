FROM mhart/alpine-node:6.9.1

ENV PORT 9797
ENV APPNAME itervent

ADD . /usr/src/app
WORKDIR /usr/src/app

RUN apk add --update python && \
    adduser -s /bin/ash -u 1000 -S $APPNAME && \
    chown -R $APPNAME . && \
    npm install --global elm@0.17.1 && \
    npm install && \
    apk --update del python make expat gdbm sqlite-libs libbz2 libffi g++ gcc && \
    rm -rf /var/cache/apk/*

USER $APPNAME

EXPOSE $PORT
