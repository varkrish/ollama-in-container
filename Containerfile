# Use UBI Micro base image
FROM registry.access.redhat.com/ubi8/ubi-minimal

MAINTAINER Varun Krishnamurthy <varkrish@redhat.com>

WORKDIR /app/ollama
# Install necessary packages
RUN microdnf  --noplugins install -y findutils curl jq && \
    microdnf --noplugins clean all && \
    curl -fsSL https://ollama.com/install.sh | sh && \
    chmod +x /usr/local/bin/ollama
ADD ollama-entrypoint.sh /app/ollama

ADD ollama-entrypoint.sh .

RUN mkdir -p .ollama && \
    chgrp -R 0 .ollama && chmod -R g=u .ollama  && \
    chmod +x /app/ollama/ollama-entrypoint.sh && \
    chgrp -R 0 /app/ollama && chmod -R g=u /app/ollama/
    
# Conditionally pull model if PULL_MODEL_BY_DEFAULT is set to true
ARG PULL_MODEL_BY_DEFAULT=false
ARG MODEL=llama3
#if the model is already available locally, we just copy to the container to avoid re-downlaoding
COPY ./models .ollama/
RUN if [ "$PULL_MODEL_BY_DEFAULT" = "true" ]; then ollama serve & sleep 50 && ollama pull $MODEL; fi
# Set default command
EXPOSE 11434
USER 1001
ENTRYPOINT ["/app/ollama/ollama-entrypoint.sh"]

