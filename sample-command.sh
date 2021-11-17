# Create mockbin service


# Create mockbin route


# Create the OIDC plugin
http --verify=false --form post https://kong-admin.k3s.local/routes/echo/plugins \
            name=openid-connect \
            config.issuer=https://keycloak.k3s.local/auth/realms/kong \
            config.client_id=kong \
            config.client_secret=ab523f45-e04a-43ec-bac7-2e268c2ff05c \
            config.response_mode=form_post \
            config.ssl_verify=false \
            config.cache_tokens_salt=rDrzmZtubsQt6ZRTWldsi8Y01FCNfiIJ \
            config.token_exchange_issuer="https://keycloak.k3s.local/auth/realms/kong" \
            config.token_exchange_client_id="kong" \
            config.token_exchange_client_secret="ab523f45-e04a-43ec-bac7-2e268c2ff05c" \
            config.token_exchange_use_bearer_header="false" \
            config.token_exchange_audience="kong-privileged" \
            config.token_exchange_grant_type="urn:ietf:params:oauth:grant-type:token-exchange" \
            config.token_exchange_token_requested_type="urn:ietf:params:oauth:token-type:refresh_token" \
            Kong-Admin-Token:password
            #config.auth_methods='[bearer]' \

TOKEN=$(curl -k -s -X POST 'https://keycloak.k3s.local/auth/realms/kong/protocol/openid-connect/token' --header 'content-type: application/x-www-form-urlencoded' --data-urlencode 'client_id=kong' --data-urlencode 'client_secret=ab523f45-e04a-43ec-bac7-2e268c2ff05c' --data-urlencode 'username=jack' --data-urlencode 'password=password' --data-urlencode 'grant_type=password' | jq -r .access_token) && echo $TOKEN
curl -k -H "Authorization: Bearer $TOKEN" https://kong-proxy.k3s.local/mockbin


# THIS IS FOR THE OLD COMPOSE ONE
TOKEN=`curl -s -X POST 'http://keycloak.kong.lan:8080/auth/realms/kong/protocol/openid-connect/token' \       --header 'content-type: application/x-www-form-urlencoded'  \
      --data-urlencode 'client_id=kong' \
      --data-urlencode 'client_secret=ab523f45-e04a-43ec-bac7-2e268c2ff05c'  \
      --data-urlencode 'username=jack'  \
      --data-urlencode 'password=password'  \
      --data-urlencode 'grant_type=password' | jq -r '.access_token'` && echo $TOKEN
curl -H "Authorization: Bearer $TOKEN" http://proxy.kong.lan/echo
