#!/bin/bash

set -e

echo ${PWD##*/}  

docker run \
    -it \
    --net="host" \
    --volume "$(pwd)/migrations:/home/app/migrations" \
    --env-file ./.env \
    ${PWD##*/}_postgres-migrator \
    $@
