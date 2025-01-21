# Ollama Docker Setup

Este projeto configura e executa o serviço [Ollama](https://ollama.ai/) utilizando Docker. O setup inclui um `Dockerfile` personalizado para instalar o `curl` e ajustar o fuso horário, além de um arquivo `docker-compose.yml` para orquestrar o container.

## Estrutura do Projeto

```
.
├── Dockerfile
├── docker-compose.yml
└── README.md
```

### Arquivos

- **Dockerfile**: Personaliza a imagem base de Ollama para instalar o `curl` e configurar o fuso horário.
- **docker-compose.yml**: Orquestra o container, expõe a porta necessária e define um healthcheck.

---

## Pré-requisitos

- Docker e Docker Compose instalados na máquina.  
  Consulte a [documentação oficial do Docker](https://docs.docker.com/get-docker/) para instruções de instalação.

---

## Como Usar

1. **Clone o repositório** (ou copie os arquivos para o seu ambiente local):
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd ollama_docker
   ```

2. **Construa a imagem personalizada**:
   ```bash
   docker-compose build
   ```

3. **Inicie os serviços**:
   ```bash
   docker-compose up -d
   ```

4. **Verifique se o container está funcionando**:
   ```bash
   docker ps
   ```

5. **Teste o serviço Ollama**:
   Verifique se o Ollama está acessível na porta 11434:
   ```bash
   curl -sSf http://localhost:11434
   ```

---

## Detalhes Técnicos

### Dockerfile

O `Dockerfile` adiciona o `curl` ao container Ollama e configura o fuso horário:
```dockerfile
FROM ollama/ollama

# Instala o curl e configura fuso horário
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Configura o fuso horário
ENV TZ=America/Sao_Paulo

# Define o comando de entrada
ENTRYPOINT ["/bin/ollama", "serve"]
```

### docker-compose.yml

O `docker-compose.yml` configura a rede, expõe a porta 11434 e adiciona um healthcheck:
```yaml
services:
  ollama:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ollama
    environment:
      - TZ=America/Sao_Paulo
    ports:
      - "11434:11434"
    healthcheck:
      test: ["CMD", "curl", "-sSf", "http://localhost:11434"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: always
    networks:
      - ollama_net

networks:
  ollama_net:
    name: ollama_net
    driver: bridge
    attachable: true
```

---

## Healthcheck

O healthcheck verifica se o Ollama está acessível na porta 11434. Caso a aplicação falhe, o Docker tentará reiniciar o container automaticamente.

---

## Troubleshooting

- **Problema**: O container não inicia.  
  **Solução**: Verifique os logs do container com:
  ```bash
  docker logs ollama
  ```

- **Problema**: O healthcheck falha.  
  **Solução**: Certifique-se de que a porta 11434 não está sendo usada por outro serviço.

---

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

---

## Licença

Este projeto é licenciado sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.
