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
    (optional) Expose `nas-tools` app on the Internet by Cloudflare Tunnel:
    ```bash
    # replace nas-tools.yuchanns.xyz to yourselves' domain
    cloudflared tunnel route dns k3slab nas-tools.yuchanns.xyz
    ```
4. I use [emby](https://emby.media/) as the Media Library:
    ```bash
    kubectl apply -f ./emby.yaml
    ```
    (optional) Expose `emby` app on the Internet by Cloudflare Tunnel:
    ```bash
    # replace emby.yuchanns.xyz to yourselves' domain
    cloudflared tunnel route dns k3slab emby.yuchanns.xyz
    ```
5. I use [jackett](https://github.com/linuxserver/docker-jackett) as the Indexer:
    ```bash
    kubectl apply -f ./jackett.yaml
    ```

[csi-rclone](https://github.com/dvcrn/csi-rclone-reloaded) for mounting alist webdav to filesystem.
