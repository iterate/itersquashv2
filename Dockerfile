FROM mhart/alpine-node:base-6.9.1

ENV PORT 9797
ENV APPNAME itervent
ENV PATH=${PATH}:/root/.yarn/bin

ADD . /usr/src/app
WORKDIR /usr/src/app

RUN apk add --update python curl tar && \
    adduser -s /bin/ash -u 1000 -S $APPNAME && \
    chown -R $APPNAME . && \
    curl -o- -L https://yarnpkg.com/install.sh | ash && \
    yarn && \
    apk --update del python make expat gdbm sqlite-libs libbz2 libffi g++ gcc curl tar && \
    rm -rf /var/cache/apk/*

USER $APPNAME

EXPOSE $PORT

CMD yarn start
