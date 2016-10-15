#!/bin/bash

set -xe

cat ./current-app-info/current-app.txt

sed "s/APPLICATION_NAME/$(cat ./current-app-info/next-app.txt)-scs-demo-onlinestore-service/" ./demo-onlinestore-service/manifest.yml > ./app-manifest-output/manifest.yml

cat ./app-manifest-output/manifest.yml