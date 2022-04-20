# Orchestrator Helm chart

## Description

It's a so called "umbrella" Helm chart for the Orchestrator as it contains
the following charts/components:

| Chart                                | Component              |
|--------------------------------------|------------------------|
| [cloudify](../cloudify/README.md)    | Cloudify manager AIO   |


## Installation

This chart is intended to be installed as a whole to deploy all the components related to the Orchestrator:

    helm install orchestrator . -n orchestrator --create-namespace

### Optional installation attributes:

| Option | Explanation |
|---|---|
| `--set global.projectDomain=<yourdomain.eu>`    | override default domain name `exampledomain.eu` |
| `--set global.tls.enabled=true`                 | enable TLS/HTTPS (termination at the Ingress level) |
| `--set cloudify.config.password=<yourPassword>` | replace Cloudify's default password during installation |
| `-f ./values/<project>.yaml`                    | apply project-specific values |

