# Home Theater

## Instructions

1. Create a Namespace:
    ```bash
    kubectl apply -f ./namespace.yaml
    ```
2. Create a PVC:
    ```bash
    kubectl apply -f ./pvc.yaml
    ```
3. I use [nas-tools](https://github.com/NAStool/nas-tools) as the Media Management Solution:
    ```bash
    kubectl apply -f ./nas-tools.yaml
    ```
4. (optional) Expose `nas-tools` app on the Internet by Cloudflare Tunnel:
    ```bash
    # replace nas-tools.yuchanns.xyz to yourselves domain
    cloudflared tunnel route dns k3slab nas-tools.yuchanns.xyz
    ```
