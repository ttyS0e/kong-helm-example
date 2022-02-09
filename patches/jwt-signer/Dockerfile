FROM kong/kong-gateway:2.5.0.0-alpine

USER root
RUN sed -i 's/local enable_hs_signatures = false/local enable_hs_signatures = true/g' /usr/local/share/lua/5.1/kong/openid-connect/jws.lua
USER kong
