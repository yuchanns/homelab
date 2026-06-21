# Operations Notes

## qBittorrent Through Kong

The qBittorrent route must preserve the original public host. Otherwise qBittorrent sees the upstream container host while browser requests carry the public origin, which triggers WebUI CSRF/origin checks and returns 401 for static assets.

The Kong route uses:

```yaml
preserve_host: true
```
