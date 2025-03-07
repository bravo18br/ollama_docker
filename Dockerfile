FROM ollama/ollama

# Instala o curl e configura fuso horário
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Sao_Paulo

ENTRYPOINT ["/bin/ollama", "serve"]
