# Keycloak Helm chart

## Description

It's a Helm chart for Keycloak which:

* has all components on board (it does not use any external DB --which
would be desirable for a production-ready deployment),
* is not highly available (has one replica only),
* does not use persistent volume to survive restarts/failures.

## Installation

This chart is intended to be installed as a dependency of the `orchestrator` umbrella chart.
However, for local testing it can be deployed/upgraded by following these steps:

    kubectl create ns orchestrator

    kubectl create secret generic keycloak \
      -n orchestrator \
      --from-literal=keycloak-admin=<adminId> \
      --from-literal=keycloak-admin-pw='<adminPassword>'

It is possible to check whether the secret was created properly by running:

    kubectl get secrets -n orchestrator keycloak -o jsonpath='{.data.keycloak-admin}' | base64 --decode
    kubectl get secrets -n orchestrator keycloak -o jsonpath='{.data.keycloak-admin-pw}' | base64 --decode

Finally, deploy/upgrade Keycloak's chart:

    helm upgrade --install keycloak . -n orchestrator

### Notes:
- Default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to
  the previous installation command.

Please check out [values.yaml](./values.yaml) for more configuration details.