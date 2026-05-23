#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 <imm-source-dir> [out-dir]" >&2
  exit 64
fi

source_dir=$(cd "$1" && pwd)
out_dir=${2:-dist}
extension_dir="$source_dir/editors/vscode/imm"

if [ ! -f "$extension_dir/package.json" ]; then
  echo "VS Code extension package.json not found: $extension_dir/package.json" >&2
  exit 1
fi

mkdir -p "$out_dir"
out_dir=$(cd "$out_dir" && pwd)
version=$(node -p "require(process.argv[1]).version" "$extension_dir/package.json")
out_file="$out_dir/imm-vscode-${version}.vsix"

(
  cd "$extension_dir"
  npm test
  npx --yes @vscode/vsce package \
    --no-dependencies \
    --allow-missing-repository \
    --out "$out_file"
)
