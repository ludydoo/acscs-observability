#!/usr/bin/env bash

oc label ns "openshift-monitoring" argocd.argoproj.io/managed-by=openshift-gitops
oc label ns "openshift-user-workload-monitoring" argocd.argoproj.io/managed-by=openshift-gitops

oc apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bootstrap
  namespace: openshift-gitops
spec:
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  source:
    repoURL: https://github.com/ludydoo/acscs-observability
    targetRevision: HEAD
    path: project
  destination:
    server: https://kubernetes.default.svc
    namespace: openshift-gitops
EOF
