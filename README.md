# Homelab

This repository contains the Docker Compose and gateway configuration for a personal homelab. It tracks service topology, reverse proxy routes, and sanitized templates for configuration that normally contains local credentials.

## Repository Layout

- `compose.yaml`: root Compose entrypoint for shared services.
- `network/compose.yaml.tpl`: network layer services, including Tailscale and Kong.
- `network/kong/kong.yml.tpl`: declarative Kong routes, services, consumers, and plugins.
- `theater/compose.yaml.tpl`: media stack services such as Jellyfin, qBittorrent, MoviePilot, OpenList, and subtitles.
- `ai/compose.yaml.tpl`: AI-related services and backing databases.
- `vm/compose.yml.tpl`: Windows VM service template.
- `env/.env.example`: environment variable reference for values removed from templates.
- `scripts/sanitize-current-config.py`: regenerates sanitized templates from live Compose and Kong config files.
- `scripts/check-tracked-secrets.sh`: scans staged files for high-confidence secret patterns before committing.
- `docs/operations.md`: operational notes for non-obvious service behavior.

## Configuration Model

Files ending in `.tpl` are sanitized templates. Real credentials, tokens, database passwords, auth keys, media data, application state, and generated runtime files are intentionally ignored by Git.

To materialize a deployment config, copy the matching template to the live filename and provide values from `env/.env.example` through your environment, a local `.env` file, or another secret manager.

## Updating Templates

After changing live Compose or Kong configuration, regenerate the tracked templates:

```sh
./scripts/sanitize-current-config.py
```

Then run the pre-commit checks:

```sh
./scripts/check-tracked-secrets.sh
docker compose -f compose.yaml config --quiet
docker compose -f network/compose.yaml.tpl config --quiet
docker compose -f theater/compose.yaml.tpl config --quiet
docker compose -f ai/compose.yaml.tpl config --quiet
docker compose -f vm/compose.yml.tpl config --quiet
```

Warnings about unset environment variables are expected when parsing templates without a populated local environment.

## Notes

This homelab intentionally uses rolling container images for most self-hosted services. The repository is optimized for readable diffs, operational recovery, and safer configuration synchronization rather than strict bit-for-bit reproducibility.
