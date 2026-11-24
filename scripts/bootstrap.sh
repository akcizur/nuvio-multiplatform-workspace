#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$ROOT_DIR/UPSTREAMS.lock"
INCLUDE_OPTIONAL=0
INCLUDE_REFERENCES=0

for arg in "$@"; do
  case "$arg" in
    --include-optional) INCLUDE_OPTIONAL=1 ;;
    --include-references) INCLUDE_REFERENCES=1 ;;
    --all) INCLUDE_OPTIONAL=1; INCLUDE_REFERENCES=1 ;;
    -h|--help)
      echo "Usage: $0 [--include-optional] [--include-references] [--all]"
      exit 0
      ;;
    *) echo "Unknown argument: $arg" >&2; exit 2 ;;
  esac
done

command -v git >/dev/null 2>&1 || { echo "Git is required but was not found." >&2; exit 1; }

fetch_one() {
  local id="$1" repo="$2" branch="$3" sha="$4" license="$5" class="$6" relpath="$7"
  local url="https://github.com/NuvioMedia/${repo}.git"
  local dest="$ROOT_DIR/$relpath"
  local tmp="${dest}.bootstrap.$$"
  mkdir -p "$(dirname "$dest")"

  if [[ -d "$dest/.git" || -f "$dest/.git" ]]; then
    local current
    current="$(git -C "$dest" rev-parse HEAD 2>/dev/null || true)"
    if [[ "$current" == "$sha" ]]; then
      echo "[ok] $id already at $sha"
      if [[ -f "$dest/.gitmodules" ]]; then git -C "$dest" submodule update --init --recursive; fi
      return 0
    fi
    if [[ -n "$(git -C "$dest" status --porcelain 2>/dev/null || true)" ]]; then
      echo "[error] $relpath has local changes; refusing to overwrite it." >&2
      return 1
    fi
    echo "[error] $relpath is at ${current:-unknown}, expected $sha." >&2
    echo "        Remove this checkout explicitly, then rerun bootstrap." >&2
    return 1
  elif [[ -e "$dest" ]]; then
    echo "[error] $dest exists but is not a Git checkout." >&2
    return 1
  fi

  echo "[clone] $id ($repo @ $sha; branch $branch; $license)"
  rm -rf "$tmp"
  mkdir -p "$tmp"
  if ! git -C "$tmp" init -q; then rm -rf "$tmp"; return 1; fi
  git -C "$tmp" remote add origin "$url"
  if ! git -C "$tmp" fetch --depth 1 origin "$sha"; then
    rm -rf "$tmp"
    echo "[error] Could not fetch pinned commit for $repo." >&2
    return 1
  fi
  git -C "$tmp" checkout --detach FETCH_HEAD
  if [[ -f "$tmp/.gitmodules" ]]; then
    git -C "$tmp" submodule update --init --recursive
  fi
  if git lfs version >/dev/null 2>&1; then
    git -C "$tmp" lfs pull || echo "[warn] Git LFS pull failed for $repo; inspect LFS files manually." >&2
    if [[ -f "$tmp/.gitmodules" ]]; then git -C "$tmp" submodule foreach --recursive 'git lfs pull || true'; fi
  fi
  mv "$tmp" "$dest"
}

while IFS='|' read -r id repo branch sha license class relpath; do
  [[ -z "${id:-}" || "$id" == \#* ]] && continue
  case "$class" in
    core) ;;
    optional) [[ "$INCLUDE_OPTIONAL" -eq 1 ]] || continue ;;
    reference) [[ "$INCLUDE_REFERENCES" -eq 1 ]] || continue ;;
    *) echo "[error] Unknown class '$class' in UPSTREAMS.lock for $id" >&2; exit 1 ;;
  esac
  fetch_one "$id" "$repo" "$branch" "$sha" "$license" "$class" "$relpath"
done < "$LOCK_FILE"

echo
echo "Bootstrap complete. Run: ./scripts/verify.sh"
