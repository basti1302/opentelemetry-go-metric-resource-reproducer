#!/usr/bin/env bash

set -xeuo pipefail

cd "$(dirname ${BASH_SOURCE})"

image_name=go-otel-sdk-metric-resource-issue-reproducer
container_name=${image_name}-container

echo "stopping and removing container $container_name"
docker rm -f $container_name || true

echo "removing image $image_name"
docker rmi -f $image_name

docker build -t go-otel-sdk-metric-resource-issue-reproducer .
docker build \
  --progress=plain \
  -t $image_name \
  .

docker run \
  --env OTEL_RESOURCE_ATTRIBUTES="service.namespace=my-service-namespace,service.name=my-service-name,service.version=1.2.3" \
  -p 8080:8080 \
  --name $container_name \
  $image_name

