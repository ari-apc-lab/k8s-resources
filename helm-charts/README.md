# Orchestrator Helm charts

## Installation

- Check [orchestrator](./orchestrator/README.md) documentation and follow instructions.

## Configuration

### Cloudify:

- Once the `orchestrator` deployment is complete Cloudify's web console/interface will be accesible at
  `http[s]://cloudify.<exampledomain.eu>`.
  - Log in using "Username" `admin` and Cloudify's password (added to `cloudify` secret created during
    `orchestrator` [deployment](./orchestrator/README.md#orchestrator-chart)).

- Build [`croupier`](https://github.com/ari-apc-lab/croupier), a plugin for HPC and batch jobs orchestration in Cloudify:

  - Clone `croupier` repository into your local and checkout the branch you want to deploy:

    ```sh
    git clone https://github.com/ari-apc-lab/croupier.git
    cd croupier
    git checkout <master_dev>
    ```

  - Create `croupier` Python wagon issuing the following command:

    ```sh
    docker run -v <absolute_path_to_croupier_folder>:/packaging cloudifyplatform/cloudify-centos-7-py3-wagon-builder
    ```

    Output:

    ```
    Wagon created successfully at: ./croupier-3.2.0-centos-Core-py36-none-linux_x86_64.wgn
    ```

- Once the wagon is created, go to "Resources" > "Plugins" > "Upload" > "Upload a package":

  <img src="./docs/images/cloudify-package.png" alt="Upload a package" title="Upload a package" width="650" />

- Browse your system and fetch the created wagon and `plugin.yaml` (it belongs to `croupier/` repository):

  <img src="./docs/images/cloudify-upload.png" alt="Upload a package" title="Upload a package" width="450" />

- After a few seconds `croupier` will be installed:

  <img src="./docs/images/cloudify-installed.png" alt="Croupier is installed" title="Croupier is installed" width="650" />

### Keycloak:

- Keycloak's web console/interface will be accesible at
  `http[s]://keycloak.<exampledomain.eu>`.
  - Log in using Keycloak's credentials (added to `keycloak` secret created
    during `orchestrator` [deployment](./orchestrator/README.md#orchestrator-chart)).
- Keycloak's required realm and client are automatically configured during `orchestrator`
  deployment using a Kubernetes job.
  This configuration can be manually extendended/modified using the web interface:
  - Add realm `<exampleRealm>`.
  - Create client `<exampleClient>`.
    - Settings:
      - Access_type: confidential
      - Implicit flow enabled: true
      - Valid redirect URIs: *
- Create users and set their passwords.
- Then get the "Client secret" from Keycloak and create the required K8s secret:
  - Go to "Configure" > "Clients" > "`<exampleClient>`":

    <img src="./docs/images/client-config.png" alt="Client configuration" title="Client configuration" width="650" />

  - Go to "Credentials" > "Regenerate Secret" > Copy "Secret":

    <img src="./docs/images/client-secret.png" alt="Client secret" title="Client secret" width="650" />

  - Create the following K8s secret using the copied "Secret":

    ```sh
    kubectl create secret generic keycloak-postinstall \
        -n <orchestrator> \
        --from-literal=client-secret='<keycloak-client-secret>'
    ```

    After that, `vault-secret-uploader` pod will change from `CreateContainerConfigError` to `Running` state.

### Vault:

- Vault's web console/interface will be accesible at `http[s]://vault.<exampledomain.eu>`.
  - Log in using "Method: Token" and Vault's token (added to `vault` secret created during
    `orchestrator` [deployment](./orchestrator/README.md#orchestrator-chart)).
- Add an authentication method:
  - Go to "Access" > "Authentication Methods" > "Enable new method":

    <img src="./docs/images/vault-method.png" alt="Enable new method" title="Enable new method" width="650" />

  - Choose "Generic" > "JWT" > "Next":

    <img src="./docs/images/vault-jwt.png" alt="Choose JWT" title="Choose JWT" width="650" />

  - "Enable Method":

    <img src="./docs/images/vault-enable.png" alt="Enable Method" title="Enable Method" width="650" />

  - Then, under "Configure JWT", set the following url for "Jwks url" field and "Save":
    ```
    http://keycloak/realms/<exampleRealm>/protocol/openid-connect/certs
    ```
    <img src="./docs/images/vault-configure-jwks.png" alt="Configure JWT" title="Configure JWT" width="650" />

- Now let's configure the required Secrets Engines:
  - Go to "Secrets" > "Enable new engine":

    <img src="./docs/images/vault-secrets.png" alt="Enable new secrets engine" title="Enable new secrets engine" width="650" />

  - Choose "Generic" > "KV" > "Next":

    <img src="./docs/images/vault-secret-kv.png" alt="Enable new secrets engine" title="Enable new secrets engine" width="650" />

  - Type "croupier" in "Path" > Expand "Method options" tab > Select "Version" 1 > "Enable Engine":

      <img src="./docs/images/vault-engine-croupier.png" alt="Enable KV secrets engine" title="Enable KV secrets engine" width="650" />

  - Repeat the previous three steps replacing "croupier" by "ssh".
