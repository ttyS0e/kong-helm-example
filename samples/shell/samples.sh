#!/bin/bash

## Usage: ./helpers.sh <function_name> <args>

function split_spec_into_two() {
  # setup
  rm -rf split_spec_into_two/*
  mkdir -p split_spec_into_two/
  cp petstore.yaml split_spec_into_two/split-petstore.yaml
  cd split_spec_into_two/

  # split the spec into separate internal and external documents
  # internal (remove all external routes)
  yq e '.paths |= with_entries( select( .value[].tags | contains(["external"] ) | not ) )' split-petstore.yaml > internal-only-petstore.yaml

  # external (remove all internal routes)
  yq e '.paths |= with_entries( select( .value[].tags | contains(["internal"] ) | not ) )' split-petstore.yaml > external-only-petstore.yaml

  # generate both with inso
  inso generate config internal-only-petstore.yaml > internal-kong-config.yaml
  inso generate config external-only-petstore.yaml > external-kong-config.yaml
}

function replace_all_property_values() {
  # setup
  rm -rf change_all_property_values/*
  mkdir -p change_all_property_values/
  cp petstore.yaml change_all_property_values/replace-petstore.yaml
  cd change_all_property_values/

  # get value from args
  export FIND_KEY=$1
  export NEW_VALUE=$2

  # find every instance of the property key and update its value
  yq eval -i '.. | select(has(env(FIND_KEY))).[env(FIND_KEY)] |= env(NEW_VALUE)' replace-petstore.yaml
}

function add_property_to_plugin() {
  # setup
  rm -rf add_property_to_plugin/*
  mkdir -p add_property_to_plugin/
  cp petstore.yaml add_property_to_plugin/add-petstore.yaml
  cd add_property_to_plugin/

  # get values from args
  export NEW_KEY=$1
  export NEW_VALUE=$2

  # add/replace it
  yq eval -i ".paths./pets.get.x-kong-plugin-key-auth.config.${NEW_KEY} = env(NEW_VALUE)" add-petstore.yaml
}

function select_all_property_key() {
  # setup
  rm -rf select_all_property_key/*
  mkdir -p select_all_property_key/
  cp petstore.yaml select_all_property_key/select-petstore.yaml
  cd select_all_property_key/

  # select the pretty-print paths to everywhere that this property key exists
  yq eval '... | select(. == "specific-config-key*") | path | join "  --->  "' select-petstore.yaml
}

function api_base_path_to_methods() {
  # setup
  rm -rf api_base_path_to_methods/*
  mkdir -p api_base_path_to_methods/
  cp petstore.yaml api_base_path_to_methods/methods-petstore.yaml
  cd api_base_path_to_methods/

  # move base path of backend to all frontend method routes
  export BASE_PROTOCOL=$(cat methods-petstore.yaml | yq eval '.servers[0].url | match("^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)").captures[0].string' -)
  export BASE_SERVER=$(cat methods-petstore.yaml | yq eval '.servers[0].url | match("^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)").captures[2].string' -)
  export BASE_PATH=$(cat methods-petstore.yaml | yq eval '.servers[0].url | match("^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)").captures[4].string' -)
  yq eval -i '.paths |= keys |= .[] |= env(BASE_PATH) + .' methods-petstore.yaml
  yq eval -i '.servers = null' methods-petstore.yaml
}

function internal_and_external() {
  # setup
  rm -rf internal_and_external/*
  mkdir -p internal_and_external/
  cp petstore.yaml internal_and_external/internal-petstore.yaml
  cp petstore.yaml internal_and_external/external-petstore.yaml
  cd internal_and_external/

  # read internal gateway url from config file, and update the servers[] block
  export API_TARGET_GATEWAY="internal"
  export PROXY_BASE_URL=$(cat ../config.yaml | yq e '.gateways[] | select(.name == env(API_TARGET_GATEWAY)) | .url' -)
  echo "Replacing servers block with URL $PROXY_BASE_URL for the $API_TARGET_GATEWAY gateway"
  yq eval -i '.servers = [], .servers += {"url": env(PROXY_BASE_URL)}' internal-petstore.yaml

  # same for external gateway
  export API_TARGET_GATEWAY="external"
  export PROXY_BASE_URL=$(cat ../config.yaml | yq e '.gateways[] | select(.name == env(API_TARGET_GATEWAY)) | .url' -)
  echo "Replacing servers block with URL $PROXY_BASE_URL for the $API_TARGET_GATEWAY gateway"
  yq eval -i '.servers = [], .servers += {"url": env(PROXY_BASE_URL)}' external-petstore.yaml
}

$*
