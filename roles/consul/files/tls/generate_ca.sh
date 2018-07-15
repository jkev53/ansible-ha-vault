#!/bin/sh

# Generate a certificate for the Consul server
echo '{"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=consul-ca.pem -ca-key=private/consul-ca-key.pem -config=cfssl.json \
    -hostname="server.node.global.consul,*.consul,localhost,127.0.0.1" - | cfssljson -bare server

# Generate a certificate for the Consul client
echo '{"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=consul-ca.pem -ca-key=private/consul-ca-key.pem -config=cfssl.json \
    -hostname="client.node.global.consul,*.consul,localhost,127.0.0.1" - | cfssljson -bare client

# Generate a certificate for the CLI
echo '{"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=consul-ca.pem -ca-key=private/consul-ca-key.pem -profile=client \
    - | cfssljson -bare cli