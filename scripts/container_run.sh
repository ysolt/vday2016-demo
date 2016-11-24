#!/bin/bash

set -xe

ENVIRONMENT=${ENVIRONMENT:-'vm'}
IMAGE_NAME=${IMAGE_NAME:-'drupal'}


if [[ $ENVIRONMENT == 'aws' ]]; then
  yum install -y epel-release; yum install -y awscli
  eval $(aws ecr get-login --region eu-central-1)
  IMAGE="${IMAGE_REPO}/${IMAGE_NAME}:${VERSION}"
  docker pull ${IMAGE}
  docker tag ${IMAGE} drupal:${VERSION}
  docker logout "https://${IMAGE_REPO}"
else 
  docker pull 10.0.2.2:5000/${IMAGE_NAME}:${VERSION}
  docker tag 10.0.2.2:5000/${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:${VERSION}
fi

mkdir -p /data/mysql /data/drupal
chown -R 27.27 /data/mysql
chown -R 997.997 /data/drupal
#docker run --restart=always -v /data/mysql:/var/lib/mysql -v /data/drupal:/var/www/drupal/sites -d --name drupal-app --privileged -p 80:80 ${IMAGE_NAME}:${VERSION}

docker run --restart=always -v /data/mysql:/var/lib/mysql -d --name drupal-app --privileged -p 80:80 ${IMAGE_NAME}:${VERSION}
