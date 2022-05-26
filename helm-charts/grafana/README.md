# Grafana Helm chart

## Description

It's a Helm chart for Grafana which:

* is not highly available (has one replica only),
* uses persistent volume to survive restarts/failures.

## Installation

This chart is intended to be installed as a dependency of the `orchestrator` umbrella chart.
However, for local testing it can be deployed by following these steps:

```sh
kubectl create ns orchestrator

kubectl create secret generic grafana \
  -n orchestrator \
  --from-literal=admin-user='<adminId>' \
  --from-literal=admin-pw='<adminPassword>'

kubectl create secret generic keycloak-postinstall \
  -n orchestrator \
  --from-literal=client-secret='<keycloak-secret>'
```

Note: the last secret is needed for the pod to start properly and its content
doesn't really matter since an isolated testing instance of Grafana
won't be able to communicate with Keycloak.

Finally, deploy Grafana's chart:

```sh
helm install grafana . -n orchestrator
```

### Notes:
- Default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to
  the previous installation command.

Please check out [values.yaml](./values.yaml) for more configuration details.