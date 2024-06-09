#FROM alpine:3.20.0 AS jre
FROM amazoncorretto:11-alpine AS jre
RUN apk update && apk upgrade && apk add --no-cache  \
    binutils \
    && rm -rf /var/cache/apk/*
RUN $JAVA_HOME/bin/jlink \
    --verbose \
    --add-modules java.base,java.management,java.naming,java.net.http,java.security.jgss,java.security.sasl,java.sql,jdk.httpserver,jdk.unsupported \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /customjre

FROM alpine:3.20.0
ENV JAVA_HOME=/jre
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --from=jre /customjre $JAVA_HOME
RUN apk update && apk upgrade && apk add --no-cache  \
    nodejs \
    npm \
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
    && echo "*/1 * * * * /firebase/export_data.sh" | crontab -

COPY . .
EXPOSE 8081 9000 8085 9199 4000 5001 9099
CMD crond -f -d 8 & firebase emulators:start --only firestore,database,pubsub,storage,auth --debug --import ./firebase-data --export-on-exit ./firebase-data
