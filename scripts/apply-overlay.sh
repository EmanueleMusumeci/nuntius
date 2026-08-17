#!/usr/bin/env bash
# Applies overlay/patches/*.patch onto a copy of the semkit submodule.
# Never touches semkit/ itself — output goes to build/semkit/ (gitignored).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/semkit"
OUT="$ROOT/build/semkit"
PATCHES="$ROOT/overlay/patches"

if [ ! -d "$SRC/.git" ] && [ ! -f "$SRC/.git" ]; then
  echo "semkit/ submodule not initialized — run: git submodule update --init" >&2
  exit 1
fi

rm -rf "$OUT"
mkdir -p "$OUT"
git -C "$SRC" archive HEAD | tar -x -C "$OUT"

count=0
shopt -s nullglob
for patch in "$PATCHES"/*.patch; do
  echo "Applying $(basename "$patch")"
  patch -p1 -d "$OUT" < "$patch"
  count=$((count + 1))
done

echo "$count patch(es) applied. Output: $OUT"
