#!/bin/bash

set -e

gcloud beta emulators firestore start --host-port=0.0.0.0:8000 &
sleep 10
/importer -f /init.d/data.json
wait $!