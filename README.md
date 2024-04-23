# Introduction

[ollama](https://ollama.com/) is a model server aiding devs to run opensource models.

[Open WebUI](https://docs.openwebui.com/) is an extensible, feature-rich, and user-friendly self-hosted WebUI designed to operate entirely offline. It supports various LLM runners, including Ollama and OpenAI-compatible APIs.

[Shell Pilot](https://github.com/reid41/shell-pilot) is a version of the chatGPT-shell-cli library , modified to support Ollama and work with local LLM, and improve some features.

This repo contains assets that containerizes ollama, OpenWebUI and help us to run the whole stack either locally using Podman Compose or deploy them on OpenShift. 

For Other Kuberenetes flavors, devs can replace `route.yaml` with appropriate `ingress.yaml`

### Local Quick Start

Running the stack locally:

1. `git clone` this repo 
2. cd into the project directory.
3. Run `podman compose up`
4. Navigate to `https://localhost:8080` to access the GUI


### Deploying on OCP


1. Review the values.yaml and update the required config  
2. Login into OpenShift using `oc login` if not logged in already
3. Create a new PVC called `model-store` with minimum size of 10 Gi
3. Run `helm upgrade --install my-chatgpt helm-charts/. -n <namespace>`
4. Once all the pods are up, navigate to the url as shown the `oc route`

### Configuration

update the below env variables defined in `compose.yml` or `values.yaml` as required:

| ENV Variable          | Description                                                                                                      | Default Value |
|-----------------------|------------------------------------------------------------------------------------------------------------------|---------------|
| PULL_MODEL_BY_DEFAULT | Determines if the model should be pulled automatically.                                                         | false         |
| MODEL                 | Name of the model to be pulled if auto-pulling is enabled.                                                        | llama3        |