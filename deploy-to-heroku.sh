#!/bin/bash

# export variables to eniveriment from .env 
source .heroku.env

# build image
docker build --cache-from $HEROKU_REGISTRY_APP_URL -t $HEROKU_REGISTRY_APP_URL .

# login heroku registry
docker login --username=_ --password=$HEROKU_AUTH_TOKEN $HEROKU_REGISTRY_DOMAIN 

# push image to registry
docker push $HEROKU_REGISTRY_APP_URL

# release image to app
IMAGE_ID=$(docker inspect $HEROKU_REGISTRY_APP_URL --format={{.Id}})
PAYLOAD='{"updates":[{"type":"web","docker_image":"'"$IMAGE_ID"'"}]}'

curl -n -X PATCH $HEROKU_API_DOMAIN/$HEROKU_APP_NAME/formation \
-d "$PAYLOAD" \
-H "Content-Type: application/json" \
-H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
-H "Authorization: Bearer $HEROKU_AUTH_TOKEN"