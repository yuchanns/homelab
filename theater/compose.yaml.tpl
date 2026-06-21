services:
  nas-tools:
    stdin_open: true
    tty: true
    container_name: nas-tools
    hostname: moviepilot-v2
    user: "0:0"
    volumes:
      - './media:/media' #媒体
      - './media/downloaded:/downloads' #媒体
      - './moviepilot/config:/config' #持久化配置
      - './moviepilot/core:/moviepilot/.cache/ms-playwright' #内核浏览器
      - './media/torrents:/torrents'  #TR种子位置
      - './qbittorrent/qBittorrent/data/data/BT_backup:/BT_backup' #QB种子位置
    environment:
      - 'MOVIEPILOT_AUTO_UPDATE=false'
      - 'NGINX_PORT=3000'
      - 'PORT=3001'
      - 'TZ=Asia/Shanghai'
      - 'SUPERUSER=admin'
      - 'SUPERUSER_PASSWORD=${MOVIEPILOT_SUPERUSER_PASSWORD}'
      - 'DB_TYPE=postgresql'
      - 'DB_POSTGRESQL_HOST=pgvector'
      - 'DB_POSTGRESQL_PORT=5432'
      - 'DB_POSTGRESQL_DATABASE=moviepilot'
      - 'DB_POSTGRESQL_USERNAME=moviepilot'
      - 'DB_POSTGRESQL_PASSWORD=${MOVIEPILOT_DB_PASSWORD}'
      - 'CACHE_BACKEND_TYPE=redis'
      - 'CACHE_BACKEND_URL=redis://:${MOVIEPILOT_REDIS_PASSWORD}@redis:6379'
    restart: always
    depends_on:
      redis:
        condition: service_healthy
    image: jxxghp/moviepilot-v2:latest
    networks:
      - homelab

  redis:
    container_name: redis
    volumes:
        - ./redis/data:/data
    image: redis
    command: redis-server --save 600 1 --requirepass ${MOVIEPILOT_REDIS_PASSWORD}
    restart: always
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - homelab
  emby:
    image: ghcr.io/jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    user: "65534:65534"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./media:/media
      - ./jellyfin:/config
      - ./jellyfin_cache:/cache
    ports:
      - "31096:8096"
    networks:
      - homelab
  qbittorent:
    image: ghcr.io/linuxserver/qbittorrent:latest
    container_name: qbittorent
    restart: unless-stopped
    user: "65534:65534"
    environment:
      TZ: "Asia/Shanghai"
    volumes:
      - "./media/downloaded:/downloads"
      - "./media/downloaded:/media/downloaded"
      - "./qbittorrent:/config"
      - "./alist:/opt/openlist/data"
    networks:
      - homelab
    ports:
      - "31097:8080"
  subfinder:
    image: allanpk716/chinesesubfinder:latest
    container_name: subfinder
    restart: unless-stopped
    user: "0:0"
    environment:
      TZ: "Asia/Shanghai"
      PERMS: "false"
    volumes:
      - "./subfinder/config:/config"
      - "./subfinder/browser:/root/.cache/rod/browser"
      - "./media:/media"
    networks:
      - homelab
  alist:
    image: openlistteam/openlist:latest
    container_name: alist
    restart: unless-stopped
    user: "65534:65534"
    environment:
      TZ: "Asia/Shanghai"
    volumes:
      - "./media:/media"
      - "./alist:/opt/openlist/data"
    ports:
      - "15244:5244"
    networks:
      - homelab

networks:
  homelab:
    external: true
