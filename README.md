# Localstack

## Overview
Contains updated CLI so Cloud Pods can be used for persistence.

## Usage
Create file `init-aws.sh`
```sh
#!/bin/bash

echo Init
FILE=/pods/main

if test -f "$FILE"; then
  echo "Restoring data from pod"
  /usr/local/bin/localstack pod load file://${FILE}
else
  echo No pod state found
fi
```

Create file `shutdown-aws.sh`
```sh
#!/bin/bash

echo Saving data to pod
localstack pod save file:///pods/main
```

Make sure the script is executable: run chmod +x init-aws.sh and on shutdown-aws.sh on the files first.

Create docker-compose.yaml
```
version: "3.8"

services:
  localstack:
    container_name: "${LOCALSTACK_DOCKER_NAME-localstack_main}"
    image: ivacko/localstack:latest
    ports:
      - "127.0.0.1:4566:4566"            # LocalStack Gateway
      - "127.0.0.1:4510-4559:4510-4559"  # external services port range
    environment:
      - DEBUG=1
      - DOCKER_HOST=unix:///var/run/docker.sock
    volumes:
    - localstack-pods:/pods
    - ./init-aws.sh:/etc/localstack/init/ready.d/init-aws.sh
    - ./shutdown-aws.sh:/etc/localstack/init/shutdown.d/shutdown.sh/shutdown-aws.sh
volumes:
  localstack-pods:
```

Run:
```
docker-compose up -d
```
