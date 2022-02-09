FROM kong/kong-gateway:2.5.0.0-alpine

USER root
RUN sed -i 's/args.get_conf_arg(config.enable_hs_signatures)/args.get_conf_arg("enable_hs_signatures")/g' /usr/local/share/lua/5.1/kong/plugins/jwt-signer/handler.lua
USER kong
