services:
  nas-tools:
    stdin_open: true
    tty: true
    container_name: nas-tools
    hostname: moviepilot-v2
    user: "0:0"
    volumes:
      - '/srv/homelab/media/library:/media' #媒体
      - '/srv/homelab/media/library/downloaded:/downloads' #媒体
      - '/srv/homelab/state/moviepilot/config:/config' #持久化配置
      - '/srv/homelab/state/moviepilot/core:/moviepilot/.cache/ms-playwright' #内核浏览器
      - '/srv/homelab/media/library/torrents:/torrents'  #TR种子位置
      - '/srv/homelab/state/qbittorrent/qBittorrent/data/data/BT_backup:/BT_backup' #QB种子位置
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
      - edge
      - media
      - data

  redis:
    container_name: redis
    volumes:
        - /srv/homelab/state/redis/data:/data
    image: redis
    command: redis-server --save 600 1 --requirepass ${MOVIEPILOT_REDIS_PASSWORD}
    restart: always
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - data
  emby:
    image: ghcr.io/jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    user: "65534:65534"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /srv/homelab/media/library:/media
      - /srv/homelab/state/jellyfin/config:/config
      - /srv/homelab/state/jellyfin/cache:/cache
    ports:
      - "31096:8096"
    networks:
      - edge
      - media
  qbittorent:
    image: ghcr.io/linuxserver/qbittorrent:latest
    container_name: qbittorent
    restart: unless-stopped
    user: "65534:65534"
    environment:
      TZ: "Asia/Shanghai"
    volumes:
      - "/srv/homelab/media/library/downloaded:/downloads"
      - "/srv/homelab/media/library/downloaded:/media/downloaded"
      - "/srv/homelab/state/qbittorrent:/config"
      - "/srv/homelab/state/alist:/opt/openlist/data"
    networks:
      - edge
      - media
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
      - "/srv/homelab/state/subfinder/config:/config"
      - "/srv/homelab/state/subfinder/browser:/root/.cache/rod/browser"
      - "/srv/homelab/media/library:/media"
    networks:
      - edge
      - media
  alist:
    image: openlistteam/openlist:latest
    container_name: alist
    restart: unless-stopped
    user: "65534:65534"
    environment:
      TZ: "Asia/Shanghai"
    volumes:
      - "/srv/homelab/media/library:/media"
      - "/srv/homelab/state/alist:/opt/openlist/data"
    ports:
      - "15244:5244"
    networks:
      - edge
      - media

networks:
  edge:
    external: true
    name: homelab_edge
  media:
    external: true
    name: homelab_media
  data:
    external: true
    name: homelab_data
