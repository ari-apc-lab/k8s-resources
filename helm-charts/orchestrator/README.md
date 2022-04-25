# Orchestrator Helm chart

## Description

It's a so called "umbrella" Helm chart for the Orchestrator as it contains
the following charts/components:

| Chart                                | Component              |
|--------------------------------------|------------------------|
| [cloudify](../cloudify/README.md)    | Cloudify manager AIO   |
| [keycloak](../keycloak/README.md)    | Keycloak               |


## Installation

This chart is intended to be installed as a whole to deploy all the components related to the Orchestrator.
Follow these steps:

    kubectl create ns orchestrator

    kubectl create secret generic cloudify \
      -n orchestrator \
      --from-literal=cloudify-admin-pw='<adminPassword>'

    kubectl create secret generic keycloak \
      -n orchestrator \
      --from-literal=keycloak-admin=<adminId> \
      --from-literal=keycloak-admin-pw='<adminPassword>'

It is possible to check whether the secret was created properly by running:

    kubectl get secrets -n orchestrator keycloak -o jsonpath='{.data.keycloak-admin}' | base64 --decode
    kubectl get secrets -n orchestrator keycloak -o jsonpath='{.data.keycloak-admin-pw}' | base64 --decode

Update dependencies:

    helm dependency update .

Finally, deploy Orchestrator's chart:

    helm install orchestrator . -n orchestrator

### Optional installation attributes:

| Option | Explanation |
|---|---|
| `--set global.projectDomain=<yourdomain.eu>`    | override default domain name `exampledomain.eu` |
| `--set global.tls.enabled=true`                 | enable TLS/HTTPS (termination at the Ingress level) |
| `--set cloudify.config.password=<yourPassword>` | replace Cloudify's default password during installation |
| `-f ./values/<project>.yaml`                    | apply project-specific values |

