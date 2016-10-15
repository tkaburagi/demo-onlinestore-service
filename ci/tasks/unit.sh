#!/bin/sh
apt-get update
apt-get install curl
curl -vvv goog;e.com
cd demo-onlinestore-service
./mvnw test