# Homelab

My Homelab Based on K3s Server and Cloudflare Tunnel.

*You are not obligated to use Cloudflare as there is no vendor lock. You can bypass and ignore the CF Tunnel and deploy your preferred instances and routes directly to the Traefik gateway.*

## Instructions

1. Deploy the K3s Server:
```bash
curl -sfL https://get.k3s.io | sh -
```
2. (optional) For Cloudflare Tunnel, check [cloudflared](./cloudflared/README.md)
3. For Home Theater, take a look on [hometheater](./hometheater/README.md).
