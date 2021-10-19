#!/bin/bash

set -e

# Set all variables from the .env file.
set -o allexport; source .env; set +o allexport

docker exec -it ${PWD##*/}-postgres-1 psql -U $DATABASE_MIGRATION_USERNAME -d $DATABASE_NAME
