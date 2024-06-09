FROM alpine:3.20.0 AS build
RUN apk update && apk upgrade && apk add --no-cache  \
    nodejs \
    npm \
    openjdk11-jre \
    dcron \
    && npm install -g firebase-tools@13.11.2 \
    && firebase setup:emulators:firestore \
    && firebase setup:emulators:database \
    && firebase setup:emulators:pubsub \
    && firebase setup:emulators:storage \
    && firebase setup:emulators:ui \
    && npm cache clean --force \
    && apk --purge del npm \
    && rm -rf /var/cache/apk/*
ENV APP_HOME /firebase
WORKDIR $APP_HOME

COPY export_data.sh /firebase/export_data.sh
RUN chmod +x /firebase/export_data.sh \
    && echo "*/1 * * * * /firebase/export_data.sh" | crontab - \
    && adduser -D -h /home/appuser appuser
USER appuser

COPY . .
EXPOSE 8081 9000 8085 9199 4000 5001 9099
CMD crond -f -d 8 & firebase emulators:start --only firestore,database,pubsub,storage,auth --debug --import ./firebase-data --export-on-exit ./firebase-data
