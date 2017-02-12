FROM mhart/alpine-node:base-7.5.0

ENV PORT 9797
ENV APPNAME app-event
ENV PATH=${PATH}:/home/$APPNAME/.yarn/bin

WORKDIR /usr/src/app

RUN apk add --update python curl tar gnupg && \
    adduser -s /bin/ash -u 1000 -S $APPNAME && \
    su -c "touch /home/$APPNAME/.profile && curl -o- -L https://yarnpkg.com/install.sh | ash" $APPNAME && \
    apk --update del python make expat gdbm sqlite-libs libbz2 libffi g++ gcc curl tar && \
    rm -rf /var/cache/apk/*

ADD package.json /usr/src/app
RUN yarn
ADD . /usr/src/app
RUN chown -R $APPNAME .

USER $APPNAME
EXPOSE $PORT

CMD yarn start
