#!/usr/bin/env bash

secret=$(openssl rand -hex 32)

cat <<EOF | kubectl apply -f-
apiVersion: v1
kind: Secret
metadata:
  name: grafana-proxy
  namespace: grafana
type: Opaque
data:
  session_secret: $(echo -n $secret | base64)
EOF