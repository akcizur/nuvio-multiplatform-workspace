#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$ROOT_DIR/UPSTREAMS.lock"
fail=0

while IFS='|' read -r id repo branch sha license class relpath; do
  [[ -z "${id:-}" || "$id" == \#* ]] && continue
  path="$ROOT_DIR/$relpath"
  if [[ ! -d "$path/.git" && ! -f "$path/.git" ]]; then
    if [[ "$class" == core ]]; then
      echo "[missing] $id ($relpath)"; fail=1
    else
      echo "[not fetched] $id ($class)"
    fi
    continue
  fi
  actual="$(git -C "$path" rev-parse HEAD 2>/dev/null || true)"
  if [[ "$actual" != "$sha" ]]; then
    echo "[mismatch] $id expected=$sha actual=${actual:-unknown}"; fail=1
  else
    echo "[ok] $id $actual"
  fi
  if [[ -f "$path/.gitmodules" ]]; then
    if git -C "$path" submodule status --recursive | grep -Eq '^[-+U]'; then
      echo "[submodule warning] $id has missing, changed or conflicted submodules"; fail=1
    fi
  fi
done < "$LOCK_FILE"

if [[ "$fail" -ne 0 ]]; then
  echo "Verification failed. See messages above." >&2
  exit 1
fi
echo "All fetched core repositories match the lockfile."
