#!/bin/bash

set -xe

pwd
env

cf api $cf-api --skip-ssl-validation

cf login -u $cf-username -p $cf-password -o "$cf-organization" -s "$cf-space"

cf apps

set +e
cf apps | grep "service" | grep green

echo "green" > ./current-app-info/current-app.txt
echo "blue" > ./current-app-info/next-app.txt

set -xe