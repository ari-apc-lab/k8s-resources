# Cloudify manager AIO helm chart

## Description

It's a Helm chart for Cloudify manager (based on https://github.com/cloudify-cosmo/cloudify-helm) which:

* has all components on board (message broker and DB are part of of the same docker container),
* is not highly available (has one replica only),
* does not use persistent volume to survive restarts/failures.

## Installation

This chart is intended to be installed as a dependency of the `orchestrator` umbrella chart.
However, for local testing it can be deployed/upgraded by running:

    helm upgrade --install cloudify-manager-aio ./cloudify -n orchestrator --create-namespace

### Notes:
- Cloudify's default domain name `exampledomain.eu` is used for testing purposes.
  It can be modified by adding `--set global.projectDomain=<yourdomain.eu>` to 
  the previous installation command.
- Cloudify's default password can be replaced during installation by adding
   `--set config.password=<yourPassword>`.
   If omitted, `testPassword!1` is used as new password for Cloudify.

Please check out [values.yaml](./values.yaml) for more configuration details.
