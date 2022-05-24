# Prometheus helm chart

## Description

It's a Helm chart for Prometheus which:

* is not highly available (has one replica only),
* uses persistent volumes to survive restarts/failures.

## Installation

This chart is intended to be installed as a dependency of the `orchestrator` umbrella chart.
However, for local testing it can be deployed/upgraded by running:

```sh
    helm install prometheus . -n orchestrator --create-namespace
```

### Notes:
- Prometheus' default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to
  the previous installation command.

Please check out [values.yaml](./values.yaml) for more configuration details.
