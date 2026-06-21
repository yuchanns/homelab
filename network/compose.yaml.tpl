services:
  pause:
    image: k8s.gcr.io/pause:3.9
    container_name: pause
    networks:
      - homelab
    restart: unless-stopped
  tailscale:
    image: tailscale/tailscale:latest
    network_mode: "service:pause"
    container_name: tailscale
    depends_on:
      - pause
    environment:
      - TS_AUTHKEY=${TS_AUTHKEY}
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_USERSPACE=false
    volumes:
      - "./tailscale:/var/lib/tailscale"
    devices:
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - net_admin
    restart: unless-stopped
  kong:
    container_name: "kong"
    restart: "unless-stopped"
    image: "kong:latest"
    depends_on:
      - pause
    network_mode: "service:pause"
    environment:
      KONG_DATABASE: "off"
      KONG_DECLARATIVE_CONFIG: "/kong/declarative/kong.yml"
      KONG_PROXY_ACCESS_LOG: "/dev/stdout"
      KONG_ADMIN_ACCESS_LOG: "/dev/stdout"
      KONG_PROXY_ERROR_LOG: "/dev/stderr"
      KONG_ADMIN_ERROR_LOG: "/dev/stderr"
    volumes:
      - "./kong:/kong/declarative"
  middleman:
    container_name: mm
    image: ghcr.io/yuchanns/middleman:latest
    restart: unless-stopped
    networks:
      - homelab

networks:
  homelab:
    external: true
