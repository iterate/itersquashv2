FROM node:6.3.1

ENV PORT 9797
ENV APPNAME app-event
ENV PATH=${PATH}:/home/$APPNAME/.yarn/bin

ADD . /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install \
       ca-certificates \
       vim-tiny \
       gcc \
       libc6-dev \
       -qqy --force-yes \
       --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --shell /bin/bash --uid 1000 --disabled-password --gecos "" $APPNAME && \
    npm install -g yarn && \
    yarn && \
    yarn global add elm@0.17.1 && \
    chown -R $APPNAME .

USER $APPNAME

EXPOSE $PORT

CMD yarn compile && yarn start
