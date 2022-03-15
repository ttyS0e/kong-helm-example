#!/bin/bash

echo CREATING CERTIFICATE FOR $1
mkdir -p ./$1/

cat > ./$1/v3.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $1

EOF

openssl req -new -nodes -out $1/server.csr -newkey rsa:2048 -keyout $1/server.key -subj "/C=GB/ST=Londonshire/L=London/O=LOCAL/CN=$1"
openssl x509 -req -in $1/server.csr -CA newca/rootCA.pem -CAkey newca/rootCA.key -CAcreateserial -out $1/server.crt -days 500 -sha256 -extfile $1/v3.ext

echo "Generated new certificates in directory $1/ - make sure that ./newca/rootCA.pem is in your OS/curl/Postman trust store."
