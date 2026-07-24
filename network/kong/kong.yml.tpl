_format_version: "2.1"
_transform: true

services:
  - name: dler
    url: http://middleman:8000
    routes:
      - name: dler-route
        hosts:
          - dl.yuchanns.xyz
        paths:
          - /
        strip_path: false
  - name: nas-tools
    url: http://nas-tools:3000
    routes:
      - name: nas-tools
        hosts:
          - nas-tools.yuchanns.xyz
        paths:
          - /
        strip_path: false
  - name: alist
    url: http://alist:5244
    routes:
      - name: alist
        hosts:
          - alist.yuchanns.xyz
        paths:
          - /
        strip_path: false
  - name: emby
    url: http://emby:8096
    routes:
      - name: emby
        hosts:
          - emby.yuchanns.xyz
        paths:
          - /
        strip_path: false
  - name: qbittorrent
    url: http://qbittorent:8080
    routes:
      - name: qbittorrent
        hosts:
          - qbittorrent.yuchanns.xyz
        paths:
          - /
        strip_path: false
        preserve_host: true
  - name: subfinder
    url: http://subfinder:19035
    routes:
      - name: subfinder
        hosts:
          - subfinder.yuchanns.xyz
        paths:
          - /
        strip_path: false
  - name: ocr
    url: http://wxocr:5000
    routes:
      - name: ocr
        hosts:
          - ocr.yuchanns.xyz
  - name: copilot
    url: http://copilot:9191
    routes:
      - name: copilot
        hosts:
          - copilot.yuchanns.xyz
  - name: router
    url: http://10.9.60.1
    routes:
      - name: router
        hosts:
          - router.yuchanns.xyz
  - name: gitlab-example
    url: http://gitlab-example:8929
    routes:
      - name: gitlab-example
        hosts:
          - git.yuchanns.xyz
        paths:
          - /
        strip_path: false
        preserve_host: true
