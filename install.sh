#!/bin/sh

set -e # -e: exit on error

if [ ! "$(command -v chezmoi)" ]; then
  echo "chezmoi ins't installed, trying to install.."
  bin_dir="$HOME/.local/bin"

  if [ "$(command -v brew)" ]; then
    echo "brew is available, installing with it..."
    sh -c "brew install chezmoi"
    bin_dir="$(brew --prefix)/bin"
  fi

  chezmoi="$bin_dir/chezmoi"

  if [ ! -f "$chezmoi" ]; then
    if [ "$(command -v curl)" ]; then
      sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
    elif [ "$(command -v wget)" ]; then
      sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
    else
      echo "To install chezmoi, you must have curl or wget installed." >&2
      exit 1
    fi
  fi

  echo "chezmoi bin is set to: $chezmoi"
else
  echo "chezmoi executable is available, using it"
  chezmoi=chezmoi
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
# exec: replace current process with chezmoi init
exec "$chezmoi" init --apply "--source=$script_dir"
