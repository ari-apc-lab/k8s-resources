# Vault secret uploader Helm chart

## Description

It's a Helm chart for Vault secret uploader which:

* is not highly available (has one replica only),
* does not use persistent volumes as it is a stateless service.

More info [here](https://github.com/ari-apc-lab/vault-secret-uploader).

## Installation

This chart is intended to be installed as a dependency of the `orchestrator` umbrella chart.
However, for local testing it can be deployed by following these steps:

    kubectl create ns orchestrator

    kubectl create secret generic vault \
      -n orchestrator \
      --from-literal=root-token='<token>'

    kubectl create secret generic keycloak-postinstall \
      -n orchestrator \
      --from-literal=client-secret='<keycloak-secret>'

Note: those secrets are needed for the pod to start properly and its content
doesn't really matter since an isolated testing instance of Vault secret uploader
won't be able to communicate with Vault or Keycloak.

Finally, deploy Vault secret uploader's chart:

    helm install vault-secret-uploader . -n orchestrator

### Notes:
- Default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to
  the previous installation command.

Please check out [values.yaml](./values.yaml) for more configuration details.