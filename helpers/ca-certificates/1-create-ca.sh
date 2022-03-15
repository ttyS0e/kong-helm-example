#!/bin/bash

#*** Usage:
#** ./1-create-ca.sh example-ca-name
#***

#!/bin/bash
mkdir -p newca/
openssl genrsa -out newca/rootCA.key 2048
openssl req -x509 -new -nodes -key newca/rootCA.key -sha256 -days 2048 -out newca/rootCA.pem -subj "/C=GB/ST=Londonshire/L=London/O=LOCAL/CN=$1-root-ca" -config rootCA_openssl.conf -extensions v3_ca
