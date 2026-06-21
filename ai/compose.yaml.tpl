services:
  wxocr:
    image: ghcr.io/yuchanns/wxocr:3.12
    container_name: wxocr
    restart: unless-stopped
    networks:
      - edge
      - ai
  copilot:
    image: ghcr.io/yuchanns/copilot-openai-api:latest
    container_name: copilot
    restart: unless-stopped
    networks:
      - edge
      - ai
    environment:
      COPILOT_TOKEN: "${COPILOT_TOKEN}"
    volumes:
      - "~/.config/github-copilot:/home/appuser/.config/github-copilot"
  pglobe:
    image: pgvector/pgvector:pg17
    networks:
      - data
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
      - data
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
  edge:
    external: true
    name: homelab_edge
  ai:
    external: true
    name: homelab_ai
  data:
    external: true
    name: homelab_data
