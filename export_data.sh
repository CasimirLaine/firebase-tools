#!/bin/sh
cd /firebase
DEST_DIR="./firebase-data-tmp"
DEST_DIR_FINAL="./firebase-data"

firebase emulators:export "$DEST_DIR" >> /firebase/cron.log 2>&1
cp -rf "$DEST_DIR/"* "$DEST_DIR_FINAL/"
rm -rf "$DEST_DIR"

echo "Firebase data backed up to $DEST_DIR_FINAL."
