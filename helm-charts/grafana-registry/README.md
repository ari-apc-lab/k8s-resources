# grafana-registry Helm chart

## Description

It's a Helm chart for grafana-registry which:

* is not highly available (has one replica only),
* does not use persistent volumes as it is a stateless service.

More info [here](https://github.com/ari-apc-lab/grafana-registry).

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

Note: these secrets are needed for the pod to start properly and their content
doesn't really matter since an isolated testing instance of grafana-registry
won't be able to communicate with Keycloak or Grafana.

```sh
helm install grafana-registry . -n orchestrator
```

### Notes:
- Default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to
  the previous installation command.

Please check out [values.yaml](./values.yaml) for more configuration details.