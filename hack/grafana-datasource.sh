#!/usr/bin/env bash

BEARER_TOKEN="$(oc create token grafana-instance-sa --duration=8760h -n grafana)"

cat <<EOF | kubectl apply -f-
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDatasource
metadata:
  name: prometheus
  namespace: grafana
spec:
  instanceSelector:
    matchLabels:
      dashboards: grafana
  datasource:
    access: proxy
    editable: true
    isDefault: true
    jsonData:
      httpHeaderName1: 'Authorization'
      timeInterval: 5s
      tlsSkipVerify: true
      prometheusType: "Thanos"
      customQueryParameters: "dedup=true"
    name: Prometheus
    secureJsonData:
      httpHeaderValue1: 'Bearer ${BEARER_TOKEN}'
    type: prometheus
    url: 'https://thanos-querier.openshift-monitoring.svc.cluster.local:9091'
EOF