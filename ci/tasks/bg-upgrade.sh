set -xe

pwd
env

cf api $cf-api --skip-ssl-validation

cf login -u $cf-username -p $cf-password -o "$cf-org" -s "$cf-space"

cf apps

cf routes

export app-domain=$app-domain
export app-preffix=$app-preffix

export NEXT_APP_COLOR=$(cat ./current-app-info/next-app.txt)
export NEXT_APP_HOSTNAME=$NEXT_APP_COLOR-$PWS_APP_SUFFIX

export CURRENT_APP_COLOR=$(cat ./current-app-info/current-app.txt)
export CURRENT_APP_HOSTNAME=$CURRENT_APP_COLOR-$PWS_APP_SUFFIX

echo "Mapping main app route to point to $NEXT_APP_HOSTNAME instance"
cf map-route $NEXT_APP_HOSTNAME $app-domain --hostname $app-preffix

cf routes

echo "Removing previous main app route that pointed to $CURRENT_APP_HOSTNAME instance"


sleep 30; #for demo

set +e
cf unmap-route $CURRENT_APP_HOSTNAME $app-domain --hostname $app-preffix
cf unmap-route $NEXT_APP_HOSTNAME $app-domain --hostname $app-preffix-temp
set -e

echo "Routes updated"

cf routes