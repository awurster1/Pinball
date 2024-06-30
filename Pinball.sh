#!/bin/sh
echo -ne '\033c\033]0;Pinball\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Pinball.arm64" "$@"
