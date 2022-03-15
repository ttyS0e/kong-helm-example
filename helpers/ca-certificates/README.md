# Creating a CA

This can be used for the mTLS plugin.

## 1. Create a CA

Create a CA with any "subject" name you want, like so:

```sh
./1-create-ca.sh my-org-name
```

## 2. Create a client certificate

Create a client certificate, signed by this CA, like so:

```sh
# DO NOT PUT ASTERISKS IN THE CERTIFICATE CLIENT'S NAME
./2-create-client-cert.sh the-client-name
```

## 3. Upload to Kong

* Create a "CA Certificate" from the file `newca/rootCA.pem`
* Copy its `ID` then add the `Mutual TLS` plugin to one of your Kong Routes, make sure to enable **"Skip Consumer Lookup"**
* Call the API using curl but with no client certificate
* Call again, adding your client certificate from stage (2) - it should work now
