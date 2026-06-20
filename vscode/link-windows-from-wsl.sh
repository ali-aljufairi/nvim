#!/usr/bin/env sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
windows_script=$(wslpath -w "$script_dir/link-user-files.ps1")
windows_source_dir=$(wslpath -w "$script_dir")
product=${1:-Code}

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$windows_script" -Product "$product" -SourceDir "$windows_source_dir" -Mode Copy