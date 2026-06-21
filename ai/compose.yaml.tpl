services:
  wxocr:
    image: ghcr.io/yuchanns/wxocr:3.12
    container_name: wxocr
    restart: unless-stopped
    networks:
      - homelab
  copilot:
    image: ghcr.io/yuchanns/copilot-openai-api:latest
    container_name: copilot
    restart: unless-stopped
    networks:
      - homelab
    environment:
      COPILOT_TOKEN: "${COPILOT_TOKEN}"
    volumes:
      - "~/.config/github-copilot:/home/appuser/.config/github-copilot"
  kagiapi:
    image: ghcr.io/yuchanns/kagiapi:latest
    container_name: kagiapi
    restart: unless-stopped
    networks:
      - homelab
    ports:
      - 18000:8000
    environment:
      KAGI_TOKEN: "${KAGI_TOKEN}"
      ACCESS_TOKEN: "${KAGIAPI_ACCESS_TOKEN}"
  pglobe:
    image: pgvector/pgvector:pg17
    networks:
      - homelab
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_DATABASE: 'postgres'
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
    volumes:
      - ./pglobe_data:/var/lib/postgresql/data
    healthcheck:
      test: [CMD-SHELL, pg_isready -d postgres -U postgres]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
  pgvector:
    image: pgvector/pgvector:pg17
    networks:
      - homelab
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_DATABASE: 'postgres'
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
    volumes:
      - ./pgvector_data:/var/lib/postgresql/data
    healthcheck:
      test: [CMD-SHELL, pg_isready -d postgres -U postgres]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
networks:
  homelab:
    external: true
