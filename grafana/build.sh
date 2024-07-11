#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OUT="${DIR}/dashboards.yaml"

# Clear dashboards.yaml
cat /dev/null > "${OUT}"

# iterate through all json dashboards in dashboards/, and create a `grafana.integreatly.org/v1beta1`
for file in "${DIR}"/dashboards/*.json; do
  FILENAME=$(basename $file)
  WITHOUT_EXT="${FILENAME%.*}"
    echo "Processing $WITHOUT_EXT"
    cat <<EOF >> "${OUT}"
---
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDashboard
metadata:
  namespace: grafana
  name: "${WITHOUT_EXT}"
spec:
  instanceSelector:
    matchLabels:
      dashboards: "grafana"
  gzipJson: |-
    $(cat $file | gzip | base64)
EOF
done