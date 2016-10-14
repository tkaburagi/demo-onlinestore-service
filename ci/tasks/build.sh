#!/bin/sh
cd demo-onlinestore-service
./mvnw clean package -DskipTests=true
mv target/*.jar ../output/demo.jar