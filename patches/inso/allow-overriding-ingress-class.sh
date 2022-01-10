#!/bin/bash
#
# This script patches the Insomnia "Inso" CLI to fix overwriting the ingress class name
# on generated Kubernetes objects.
#
# Requires a connected Docker daemon.
mkdir -p ./out
CONTAINER_ID=$(docker run -dt --rm -v $(pwd)/out:/host --name inso-builder alpine:3.14.3)

# Install requirements
docker exec -it $CONTAINER_ID ash -c "apk add --update nodejs npm libcurl"
docker exec -it $CONTAINER_ID ash -c "npm install --global pkg insomnia-inso"

# Patch Inso
docker exec -it $CONTAINER_ID ash -c "cd /usr/local/lib/node_modules/insomnia-inso/ && cat << EOF > script.ed
103i
            ...coreAnnotations,
.
106d
w
q
EOF"
docker exec -it $CONTAINER_ID ash -c "cd /usr/local/lib/node_modules/insomnia-inso/ && ed node_modules/openapi-2-kong/dist/kubernetes/generate.js < script.ed"

# Build Inso standalone executables
docker exec -it $CONTAINER_ID ash -c "cd /usr/local/lib/node_modules/insomnia-inso/ && pkg . --target node14-alpine-x64 && mv insomnia-inso insomnia-inso-alpinelinux"
docker exec -it $CONTAINER_ID ash -c "cd /usr/local/lib/node_modules/insomnia-inso/ && pkg ."

# Copy them to the host volume
docker exec -it $CONTAINER_ID ash -c "cd /usr/local/lib/node_modules/insomnia-inso/ && ls -larth"
docker exec -it $CONTAINER_ID ash -c "cd /usr/local/lib/node_modules/insomnia-inso/ && cp insomnia-inso* /host"

# Clean and quit
docker exec -it $CONTAINER_ID ash -c "chmod 777 /host/*"
docker kill $CONTAINER_ID
