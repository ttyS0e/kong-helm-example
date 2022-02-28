#!/bin/bash

cat << EOF >> patch.ed
1060i
        introspected = true
.

1549d
1549i
            log("error introspecting token to verify required ", name, " (", err, ")")
.

w
q
EOF

cat << EOF >> Dockerfile
FROM kong/kong-gateway:2.7.1.2-alpine

USER root
COPY patch.ed patch.ed
RUN ed /usr/local/share/lua/5.1/kong/plugins/openid-connect/handler.lua < patch.ed
USER kong
EOF

docker build -t kong/kong-gateway:2.7.1.2-alpine .
