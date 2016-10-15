#!/bin/sh
apt-get update
apt-get install curl
cd demo-onlinestore-service
./mvnw test