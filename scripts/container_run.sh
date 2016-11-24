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
  mkdir -p /vagrant /data
  yum install -y wget
  wget https://s3.eu-central-1.amazonaws.com/vday2016-demo/data.tgz -O /vagrant/data.tgz
else 
  docker pull 10.0.2.2:5000/${IMAGE_NAME}:${VERSION}
  docker tag 10.0.2.2:5000/${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:${VERSION}
fi

mkdir -p /data/
tar xfz /vagrant/data.tgz -C /data
chown -R 27.27 /data/mysql
chown -R 997.997 /data/drupal

docker run --restart=always -v /data/mysql:/var/lib/mysql -v /data/drupal:/var/www/drupal/sites -d --name drupal-app --privileged -p 80:80 ${IMAGE_NAME}:${VERSION}
