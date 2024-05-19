# firebase-tools-config

## Firebase Emulators Dockerized

This repository provides a Docker configuration to run Firebase emulators, simplifying local development for
Firebase-based applications.

## Features

- Dockerized Firebase services including Firestore, Realtime Database, Storage, Pub/Sub, and Auth.
- Fully configurable via the provided `firebase.json`.
- Firebase Emulators UI integrated for easy management of Firebase services.

## Requirements

- Docker

## Setup

### Building the Docker Image

To create the Docker image equipped with Firebase emulators, run:

```bash
docker build -t firebase-emulators .
```

To run the Docker container with the Firebase emulators, execute:

```bash
docker run -p 4000:4000 -p 8081:8081 -p 9000:9000 -p 8085:8085 -p 9199:9199 -p 9099:9099 firebase-emulators
```

### Accessing the Firebase Emulators UI

To access the Firebase Emulators UI, navigate to `http://localhost:4000`.

## Configuration

The Firebase emulators are configured via the `firebase.json` file. The configuration file is mounted to the Docker container
and is used to define the services to be emulated.
