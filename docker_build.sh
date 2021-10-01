#!/bin/bash
./docker_clean.sh
docker-compose build
docker-compose up -d