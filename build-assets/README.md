# Ollama Server Docker Image

The `build-assets` folder contains all the artifacts required to build the following container images:

| FileName         | Description                                                                                                      |
|------------------|------------------------------------------------------------------------------------------------------------------|
| Containerfile    | This file containerizes Ollama, allowing the addition of locally pre-downloaded models to be part of the container. The presence of a `models` folder locally is mandatory, even if it's empty. Note that the Containerfile can still download the models during container build time. |
| modeless.Containerfile | This file is similar to Containerfile but excludes the `ADD models/ .` statement.                                      |
| ui.Containerfile | This file optimizes the existing OpenWebUI image `docker.io/dyrnq/open-webui:git-b67f80f-ollama` to run on OCP. |

### Environment Variables

| ENV Variable          | Description                                                                                                      | Default Value |
|-----------------------|------------------------------------------------------------------------------------------------------------------|---------------|
| PULL_MODEL_BY_DEFAULT | Determines if the model should be pulled automatically.                                                         | false         |
| MODEL                 | Name of the model to be pulled if auto-pulling is enabled.                                                        | llama3        |

### Building the Container Images

| Desired Container image                              | Command                                                                                                          |
|-------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| Ollama model server without models                    | `podman build -t ollama:latest -f modeless.Containerfile`                                                        |
| Ollama model server with locally pre-downloaded models| `podman build -t ollama:<modelname> -f Containerfile`                                                            |
| Ollama model server with embedded models downloaded during build time | `podman build -t ollama:<modelname> -f Containerfile --build-arg PULL_MODEL_BY_DEFAULT=true --build-arg MODEL=<Required model>` |
| Build OpenWebGUI container image                      | `podman build -t openwebgui:latest -f ui.Containerfile`                                                           |

## Ports

The container exposes port 11434 (configurable) for Ollama communication.

## User

The container runs as user ID 1001 (non-root) for security reasons.

## Entrypoint

The container's entrypoint script is `/app/ollama/ollama-entrypoint.sh`. This script attempts to download the specified model during startup if the model is not available.
