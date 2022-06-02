# Orchestrator Helm chart

## Description

It's a so called "umbrella" [Helm](https://helm.sh/) chart for the Orchestrator
as it contains the following charts/components:

| Chart                                                       | Component              |
|-------------------------------------------------------------|------------------------|
| [cloudify](../cloudify/README.md)                           | Cloudify manager AIO   |
| [keycloak](../keycloak/README.md)                           | Keycloak               |
| [vault](../vault/README.md)                                 | Vault                  |
| [vault-secret-uploader](../vault-secret-uploader/README.md) | Vault secret uploader  |
| [prometheus](../prometheus/README.md)                       | Prometheus             |
| [hpc-exporter](../hpc-exporter/README.md)                   | HPC exporter           |
| [grafana](../grafana/README.md)                             | Grafana                |
| [grafana-registry](../grafana-registry/README.md)           | grafana-registry       |

## Installation

### Requirements

- NGINX Ingress:

  If not installed, install the NGINX Ingress Controller in your Kubernetes cluster.

  **Note**: this is cluster-wide (the Ingress Controller requires a number of custom
  resource definitions (CRDs) installed in the cluster), so make sure you do not
  overwrite existing installation.

  Detailed information about installation using Helm can be found
  [here](https://github.com/nginxinc/kubernetes-ingress/tree/main/deployments/helm-chart#nginx-ingress-controller-helm-chart).

- Cert-manager:

  If you want to use TLS/HTTPS (termination at the Ingress level),
  configure Nginx to use production ready TLS certificates
  via [cert-Manager](https://cert-manager.io/).
  This is a Kubernetes addon to automate the management and issuance of TLS
  certificates from various issuing sources.
  It will ensure certificates are valid and up to date periodically, and
  attempt to renew certificates at an appropriate time before expiry.

  **Note**: this is cluster-wide (cert-manager requires a number of custom
  resource definitions (CRDs) installed in the cluster), so make sure you
  do not overwrite existing installation.

  Detailed information:
  - https://cert-manager.io/docs/usage/ingress/
  - https://www.digitalocean.com/community/tech_talks/securing-your-kubernetes-ingress-with-lets-encrypt
  - https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers/blob/main/03-setup-ingress-controller/nginx.md#step-5---configuring-production-ready-tls-certificates-for-nginx
  - https://artifacthub.io/packages/helm/cert-manager/cert-manager

  To install cert-manager using Helm (release name `cert-manager`), run:

  ```sh
  # Add the Jetstack Helm repository
  helm repo add jetstack https://charts.jetstack.io

  # Install the cert-manager helm chart
  helm install cert-manager jetstack/cert-manager --version v1.8.0 \
      --namespace cert-manager \
      --create-namespace \
      --set installCRDs=true \
      --set prometheus.enabled=false
  ```

  To inspect Kubernetes resources created:

  ```sh
  kubectl get all -n cert-manager
  kubectl get crd -l app.kubernetes.io/name=cert-manager
  ```

  To uninstall/delete the cert-manager deployment:

  ```sh
  helm uninstall -n cert-manager cert-manager
  ```

  The previous command removes all the Kubernetes components associated
  with the chart (CRDs) and deletes the release.


### Orchestrator chart

This chart is intended to be installed as a whole to deploy all the components related to the Orchestrator.
Follow these steps:

- Create K8s namespace for the deployment:

  ```sh
  kubectl create ns <orchestrator>
  ```

- Create K8s required secrets. These will contain credentials for Cloudify,
  Keycloak, Vault and (optionally) Grafana:

  ```sh
  # Note: Cloudify uses 'admin' as login ID
  kubectl create secret generic cloudify \
    -n <orchestrator> \
    --from-literal=cloudify-admin-pw='<adminPassword>'

  kubectl create secret generic keycloak \
    -n <orchestrator> \
    --from-literal=keycloak-admin='<adminId>' \
    --from-literal=keycloak-admin-pw='<adminPassword>'

  kubectl create secret generic vault \
    -n <orchestrator> \
    --from-literal=root-token='<adminToken>'

  kubectl create secret generic grafana \
    -n orchestrator \
    --from-literal=admin-user='<adminId>' \
    --from-literal=admin-pw='<adminPassword>'
  ```

  Note: you can use a random password/token generator like
  [Sordum](https://www.sordum.org/passwordgenerator/)
  to fill the secrets (especially for Vault's token), e.g.:

  <img src="./images/token-generator.png" alt="Token generator example" title="Token generator example" width="450" />

- It is possible to check whether the secrets were created properly, e.g.:

  ```sh
  kubectl get secrets -n <orchestrator> keycloak -o jsonpath='{.data.keycloak-admin}' | base64 --decode
  ```

- Update chart dependencies:

  ```sh
  helm dependency update .
  ```

- Add project-specific configuration `<project>.yaml` under [`values/`](./values/). E.g.:

  ```yaml
  # Values for orchestrator umbrella chart.
  #   Project: Example
  #
  # This is a YAML-formatted file.

  global:
    projectDomain: "exampledomain.eu"
    tls:
      enabled: false
    config:
      keycloakRealm: "exampleRealm"
      keycloakClient: "exampleClient"
  ```


- Finally, deploy Orchestrator's chart:

  ```sh
  helm install orchestrator . [-f ./values/<project>.yaml] [options] -n <orchestrator>
  ```

  Notes:
  - use "`-f ./values/<project>.yaml`" option to apply project-specific values.
  - use "`--set global.debugMode.enabled=true`" option to activate debug mode for
    `vault-secret-uploader` and `grafana-registry`.
    This enables communication towards Keycloak using `ingress` instead
    of `service`. This is required for debugging since Keycloak's JWT
    token is obtained from outside the cluster and it is only valid for
    the same endpoint.
  - chart deployment will be finished once the status of `keycloak-configjob` job
    becomes "Completed"
    (depending on the environment, it may take several minutes).
  - `vault-secret-uploader`, `grafana` and `grafana-registry` pods will remain
    in state `CreateContainerConfigError` until `keycloak-postinstall` secret
    is created. See [configuration](../README.md#keycloak) section for more information.