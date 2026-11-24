#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$ROOT_DIR/UPSTREAMS.lock"
seen='|'
count=0
while IFS='|' read -r id repo branch sha license class relpath; do
  [[ -z "${id:-}" || "$id" == \#* ]] && continue
  [[ -n "${repo:-}" && -n "${branch:-}" && -n "${sha:-}" && -n "${license:-}" && -n "${class:-}" && -n "${relpath:-}" ]] || { echo "Incomplete row: $id" >&2; exit 1; }
  [[ "$sha" =~ ^[0-9a-f]{40}$ ]] || { echo "Invalid commit SHA for $id: $sha" >&2; exit 1; }
  [[ "$class" == core || "$class" == optional || "$class" == reference ]] || { echo "Invalid class for $id: $class" >&2; exit 1; }
  [[ "$repo" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "Invalid repo name for $id" >&2; exit 1; }
  [[ "$relpath" != /* && "$relpath" != *..* ]] || { echo "Unsafe path for $id" >&2; exit 1; }
  [[ "$seen" != *"|$id|"* ]] || { echo "Duplicate id: $id" >&2; exit 1; }
  seen+="$id|"
  count=$((count+1))
done < "$LOCK_FILE"
[[ "$count" -gt 0 ]] || { echo "No upstream rows found." >&2; exit 1; }
echo "Validated $count upstream entries."
