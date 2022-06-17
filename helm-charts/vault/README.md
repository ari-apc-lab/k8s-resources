# Vault Helm chart

## Description

It's a Helm chart for Vault which:

* starts Vault as a server in ["dev" mode](https://www.vaultproject.io/docs/concepts/dev-server),
* is not highly available (has one replica only),
* does not use persistent volume to survive restarts/failures.

More info [here](https://hub.docker.com/_/vault/).

## Installation

This chart is intended to be installed as a dependency of the `orchestrator` umbrella chart.
However, for local testing it can be deployed by following these steps:

    kubectl create ns orchestrator

    kubectl create secret generic vault \
      -n orchestrator \
      --from-literal=root-token='<token>'

It is possible to check whether the secret was created properly by running:

    kubectl get secrets -n orchestrator vault -o jsonpath='{.data.root-token}' | base64 --decode

Finally, deploy Vault's chart:

    helm install vault . -n orchestrator

### Notes:
- Default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to
  the previous installation command.

Please check out [values.yaml](./values.yaml) for more configuration details.