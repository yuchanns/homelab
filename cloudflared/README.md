# Cloudflared

[Expose K8s Apps to the Internet](https://developers.cloudflare.com/cloudflare-one/tutorials/many-cfd-one-tunnel/).

## Depends

* You should have downloaded the binary [cloudflared](https://github.com/cloudflare/cloudflared)

## Instructions

1. Create a Namespace:
    ```bash
    kubectl apply -f ./namespace.yaml
    ```
2. Create a Cloudflare Tunnel:
    ```bash
    cloudflared tunnel create k3slab
    ```
    You should get a tunnel k3slab with a `${TUNNELID}`.

3. Create a Tunnel Route DNS:
    ```bash
    cloudflared tunnel route dns k3slab alist.yuchanns.xyz
    ```
    **Note** that you should replace the route to yourselves'.
    
4. Then create cloudflared associated resouces:
    ```bash
    # Upload the Tunnel credentials file to k3s
    kubectl create secret generic tunnel-credentials \
        --from-file=credentials.json=${HOME}/.cloudflared/${TUNNELID}.json -n cloudflared
    ```
    **Note** that you should replace the ingress domains in `config.yaml` in `cloudflared.yaml` to yourselves'. Apply cloudflared configuration:
    ```bash
    kubectl apply -f ./cloudflared.yaml
    ```

