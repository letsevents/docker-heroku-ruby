#!/usr/bin/env bash

BASE_DIR=$(realpath $(dirname $0)/..)
DOCKER_USER=lets
IMAGE=docker-heroku-ruby
REPO=$DOCKER_USER/$IMAGE

cd $BASE_DIR \
&& docker build --build-arg USER_ID=$UID --rm -t $REPO:ruby2.7-latest . \
&& docker tag $REPO:ruby2.7-latest $REPO:ruby2.7-$(cat VERSION) \
&& echo "$REPO:$(cat VERSION) is the lastest" \
&& echo -e "\nUse: docker push ${REPO} to upload this image"
