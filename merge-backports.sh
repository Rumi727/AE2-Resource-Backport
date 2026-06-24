#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$ROOT_DIR/AE2 Backport Integration"
TARGET_ASSETS="$TARGET_DIR/assets"
PACK_SOURCE="$ROOT_DIR/AE2 Backport/pack.mcmeta"
ICON_SOURCE="$ROOT_DIR/AE2 Backport/pack.png"

if [[ ! -f "$PACK_SOURCE" ]]; then
  echo "Missing pack.mcmeta: $PACK_SOURCE" >&2
  exit 1
fi

if [[ ! -f "$ICON_SOURCE" ]]; then
  echo "Missing pack.png: $ICON_SOURCE" >&2
  exit 1
fi

mapfile -d '' SOURCE_DIRS < <(
  find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -name '*Backport*' -print0 |
    sort -z
)

if [[ ${#SOURCE_DIRS[@]} -eq 0 ]]; then
  echo "No Backport folders found." >&2
  exit 1
fi

rm -rf -- "$TARGET_ASSETS"
mkdir -p -- "$TARGET_ASSETS"

for source_dir in "${SOURCE_DIRS[@]}"; do
  [[ "$source_dir" == "$TARGET_DIR" ]] && continue

  source_assets="$source_dir/assets"
  [[ -d "$source_assets" ]] || continue

  echo "Merging assets from: ${source_dir#$ROOT_DIR/}"
  cp -a -- "$source_assets/." "$TARGET_ASSETS/"
done

cp -a -- "$PACK_SOURCE" "$TARGET_DIR/pack.mcmeta"
cp -a -- "$ICON_SOURCE" "$TARGET_DIR/pack.png"
echo "Updated: ${TARGET_DIR#$ROOT_DIR/}"
