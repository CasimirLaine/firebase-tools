FROM --platform=linux/amd64 alpine:3.16.2 AS build
WORKDIR /firebase_tools
RUN apk update && apk add --no-cache  \
    curl \
    && rm -rf /var/cache/apk/* \
    && curl -sL https://firebase.tools/bin/linux/latest -o firebase \
    && chmod +x ./firebase

FROM --platform=linux/amd64 alpine:3.16.2
WORKDIR /firebase_tools
COPY --from=build /firebase_tools/firebase .
COPY . .
COPY export_data.sh ./export_data.sh
ENV PATH="${PATH}:/firebase_tools"
RUN apk update && apk add --no-cache \
    nodejs \
    npm \
    openjdk11-jre \
    dcron \
    gcompat \
    bash \
    sudo \
    && rm -rf /var/cache/apk/* \
    && chmod +x /firebase_tools/export_data.sh \
    && echo "*/1 * * * * /firebase_tools/export_data.sh" | crontab -
EXPOSE 8081 9000 8085 9199 4000 5001 9099
CMD firebase emulators:start --only firestore,database,pubsub,storage,auth --debug --import ./firebase-data --export-on-exit ./firebase-data
#crond -f -d 8
