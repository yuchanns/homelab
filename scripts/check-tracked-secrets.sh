#!/usr/bin/env bash
set -euo pipefail

patterns=(
  "gho_[A-Za-z0-9_]+"
  "github_pat_[A-Za-z0-9_]+"
  "glpat-[A-Za-z0-9_-]+"
  "sk-[A-Za-z0-9_-]{20,}"
  "AKIA[0-9A-Z]{16}"
  "cloudflared tunnel credentials"
  "BEGIN .*PRIVATE KEY"
)

for pattern in "${patterns[@]}"; do
  if git grep --cached -n -E "$pattern" -- . ":!scripts/check-tracked-secrets.sh"; then
    echo "Potential secret matched pattern: $pattern" >&2
    exit 1
  fi
done

echo "No high-confidence staged secret patterns found."
