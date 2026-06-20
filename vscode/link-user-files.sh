#!/usr/bin/env sh

set -eu

product=${1:-Code}
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
timestamp=$(date +%Y%m%d%H%M%S)

case "$(uname -s)" in
  Darwin)
    user_dir="$HOME/Library/Application Support/$product/User"
    ;;
  Linux)
    case "$product" in
      Code)
        user_dir="$HOME/.config/Code/User"
        ;;
      "Code - Insiders")
        user_dir="$HOME/.config/Code - Insiders/User"
        ;;
      VSCodium)
        user_dir="$HOME/.config/VSCodium/User"
        ;;
      Cursor)
        user_dir="$HOME/.config/Cursor/User"
        ;;
      *)
        user_dir="$HOME/.config/$product/User"
        ;;
    esac
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

mkdir -p "$user_dir"

link_file() {
  source_file=$1
  target_file=$2

  if [ ! -e "$source_file" ]; then
    return 0
  fi

  if [ -L "$target_file" ]; then
    current_target=$(readlink "$target_file" || true)
    if [ "$current_target" = "$source_file" ]; then
      echo "Already linked: $target_file"
      return 0
    fi
  fi

  if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    mv "$target_file" "$target_file.backup.$timestamp"
  fi

  ln -s "$source_file" "$target_file"
  echo "Linked $target_file -> $source_file"
}

link_file "$script_dir/settings.json" "$user_dir/settings.json"
link_file "$script_dir/keybindings.json" "$user_dir/keybindings.json"
link_file "$script_dir/mcp.json" "$user_dir/mcp.json"