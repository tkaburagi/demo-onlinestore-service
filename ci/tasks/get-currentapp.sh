#!/bin/bash

set -xe

pwd
env

cf api $cf-api --skip-ssl-validation

cf login -u $cf-username -p $cf-password -o "$cf-organization" -s "$cf-space"

cf apps

set +e

cf apps | grep "service" | grep green

if [ $? -eq 0 ]
then
  echo "green" > ./current-app-info/current-app.txt
  echo "blue" > ./current-app-info/next-app.txt
else
  echo "blue" > ./current-app-info/current-app.txt
  echo "green" > ./current-app-info/next-app.txt
fi
set -xe

echo "Current main app routes to app instance $(cat ./current-app-info/current-app.txt)"
echo "New version of app to be deployed to instance $(cat ./current-app-info/next-app.txt)"