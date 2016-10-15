#!/bin/bash

set -xe

env

cf api "$cf-api" --skip-ssl-validation

cf login -u "$cf-username" -p "$cf-password" -o "$cf-org" -s "$cf-space"

cf apps

cf routes

# export PWS_DOMAIN_NAME=$PWS_APP_DOMAIN
# export MAIN_ROUTE_HOSTNAME=main-$PWS_APP_SUFFIX

# export NEXT_APP_COLOR=$(cat ./current-app-info/next-app.txt)
# export NEXT_APP_HOSTNAME=$NEXT_APP_COLOR-$PWS_APP_SUFFIX

# export CURRENT_APP_COLOR=$(cat ./current-app-info/current-app.txt)
# export CURRENT_APP_HOSTNAME=$CURRENT_APP_COLOR-$PWS_APP_SUFFIX

cf map-route  $PWS_DOMAIN_NAME --hostname $MAIN_ROUTE_HOSTNAME

cf routes

echo "Removing previous main app route that pointed to $CURRENT_APP_HOSTNAME instance"

set +e
cf unmap-route $CURRENT_APP_HOSTNAME $PWS_DOMAIN_NAME --hostname $MAIN_ROUTE_HOSTNAME
set -e

echo "Routes updated"

