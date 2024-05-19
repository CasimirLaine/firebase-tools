FROM alpine:3.16.2 AS build
RUN apk update && apk add --no-cache  \
    npm \
    openjdk11-jre \
    bash \
    && rm -rf /var/cache/apk/*
RUN npm install -g firebase-tools@11.14.4 \
    && firebase setup:emulators:firestore \
    && firebase setup:emulators:database \
    && firebase setup:emulators:pubsub \
    && firebase setup:emulators:storage \
    && firebase setup:emulators:ui
ENV APP_HOME /firebase
WORKDIR $APP_HOME
ARG GOOGLE_APPLICATION_CREDENTIALS=$APP_HOME/credentials/firebase-emulator-agent.json
COPY . .
EXPOSE 8081
EXPOSE 9000
EXPOSE 8085
EXPOSE 9199
EXPOSE 4000
EXPOSE 5001
EXPOSE 9099
CMD firebase emulators:start --only firestore,database,pubsub,storage,auth --debug
