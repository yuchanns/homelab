# Homelab

My Homelab Based on K3s Server and Cloudflare Tunnel.

*You are not obligated to use Cloudflare as there is no vendor lock. You can bypass and ignore the CF Tunnel and deploy your preferred instances and routes directly to the Cilium Gateway.*

## Instructions

1. Deploy the K3s Server:
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy --disable traefik --disable-kube-proxy' sh -

# Gateway API
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.0.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.0.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.0.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.0.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.0.0/config/crd/experimental/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.0.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Install Cilium
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

sudo -E cilium install --version 1.15.4 --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16",kubeProxyReplacement=true,k8sServiceHost=${API_SERVER_IP},k8sServicePort=${API_SERVER_IP},gatewayAPI.enabled=true,hubble.relay.enabled=true,hubble.ui.enabled=true
```
2. (optional) For Cloudflare Tunnel, check [cloudflared](./cloudflared/README.md)
3. For Home Theater, take a look on [hometheater](./hometheater/README.md).
