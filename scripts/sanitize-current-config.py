#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative: str) -> str:
    return (ROOT / relative).read_text()


def write(relative: str, content: str) -> None:
    path = ROOT / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def replace_env_value(content: str, key: str, placeholder: str) -> str:
    value = f"${{{placeholder}}}"
    patterns = [
        (
            rf"(?m)^(\s*-\s*{re.escape(key)}=).*?(\x27)?$",
            lambda match: f"{match.group(1)}{value}{match.group(2) or ''}",
        ),
        (
            rf"(?m)^(\s*-\s*\x27{re.escape(key)}=).*?(\x27)$",
            lambda match: f"{match.group(1)}{value}{match.group(2)}",
        ),
        (
            rf"(?m)^(\s*#?\s*{re.escape(key)}:\s*).*$",
            lambda match: f'{match.group(1)}"{value}"',
        ),
        (
            rf"(?m)^(\s*#\s*-\s*\x27{re.escape(key)}=).*?(\x27)$",
            lambda match: f"{match.group(1)}{value}{match.group(2)}",
        ),
        (
            rf"(?m)^(\s*#\s*-\s*{re.escape(key)}=).*$",
            lambda match: f"{match.group(1)}{value}",
        ),
    ]
    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content)
    return content


def sanitize_network_compose() -> None:
    content = read("network/compose.yaml")
    content = re.sub(r"(?m)^(\s*-\s*TS_AUTHKEY=).*$", r"\1${TS_AUTHKEY}", content)
    write("network/compose.yaml.tpl", content)


def sanitize_kong() -> None:
    content = read("network/kong/kong.yml")
    write("network/kong/kong.yml.tpl", content)


def sanitize_theater_compose() -> None:
    content = read("theater/compose.yaml")
    replacements = {
        "SUPERUSER_PASSWORD": "MOVIEPILOT_SUPERUSER_PASSWORD",
        "DB_POSTGRESQL_PASSWORD": "MOVIEPILOT_DB_PASSWORD",
    }
    for key, placeholder in replacements.items():
        content = replace_env_value(content, key, placeholder)
    content = re.sub(
        r"redis://:[^@]+@redis:6379",
        r"redis://:${MOVIEPILOT_REDIS_PASSWORD}@redis:6379",
        content,
    )
    content = re.sub(
        r"(?m)^(\s*command:\s*redis-server --save 600 1 --requirepass\s+).*$",
        r"\1${MOVIEPILOT_REDIS_PASSWORD}",
        content,
    )
    write("theater/compose.yaml.tpl", content)


def sanitize_ai_compose() -> None:
    content = read("ai/compose.yaml")
    replacements = {
        "COPILOT_TOKEN": "COPILOT_TOKEN",
        "KAGI_TOKEN": "KAGI_TOKEN",
        "ACCESS_TOKEN": "KAGIAPI_ACCESS_TOKEN",
        "POSTGRES_PASSWORD": "POSTGRES_PASSWORD",
    }
    for key, placeholder in replacements.items():
        content = replace_env_value(content, key, placeholder)
    write("ai/compose.yaml.tpl", content)


def sanitize_vm_compose() -> None:
    content = read("vm/compose.yml")
    content = re.sub(r"(?m)^(\s*PASSWORD:\s*).*$", r"\1${WINDOWS_PASSWORD}", content)
    write("vm/compose.yml.tpl", content)


def main() -> None:
    sanitize_network_compose()
    sanitize_kong()
    sanitize_theater_compose()
    sanitize_ai_compose()
    sanitize_vm_compose()


if __name__ == "__main__":
    main()
