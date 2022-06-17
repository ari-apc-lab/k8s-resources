# hpc-exporter Helm chart

## Description

It's a Helm chart for hpc-exporter which:

* is not highly available (has one replica only),
* does not use persistent volumes as it is a stateless service.

More info [here](https://github.com/ari-apc-lab/hpc-exporter).

## Installation

This chart is intended to be installed as a dependency of the `orchestrator` umbrella chart.
However, for local testing it can be deployed by running:

```sh
helm install hpc-exporter . -n orchestrator --create-namespace
```

### Notes:
- Default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to
  the previous installation command.

Please check out [values.yaml](./values.yaml) for more configuration details.