#!/bin/sh

if [ ! "$(command -v fnm)" ]; then
  echo "fnm ins't installed, trying to install.."
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi
