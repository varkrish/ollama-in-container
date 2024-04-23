FROM docker.io/dyrnq/open-webui:git-b67f80f-ollama
USER root

RUN  chgrp -R 0 /app/backend && chmod -R g=u /app/backend 
VOLUME [ "/app/backend/data" ]
USER 1001
ENV USE_OLLAMA_DOCKER false
EXPOSE 8080