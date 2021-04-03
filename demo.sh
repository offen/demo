#!/bin/bash

# Copyright 2020 - Offen Authors <hioffen@posteo.de>
# SPDX-License-Identifier: MPL-2.0

set -eo pipefail

download () {
  tmpdir=$(mktemp -d /tmp/tmp.XXXXXXX)
  echo "Downloading binaries into $tmpdir ..."
  cd $tmpdir
  curl -sSL https://get.offen.dev | tar -xz
  if [[ $(command -v md5sum) ]]; then
    echo ""
    echo "Verifying download checksums ..."
    md5sum -c checksums.txt
  fi
  echo ""
  echo "Done preparing. Next we'll be launching your demo."
}

pull () {
  echo ""
  echo "Pulling latest Docker image ..."
  docker pull offen/offen:latest
}

run_demo () {
  case "$1" in
    Linux*)
      download
      ./offen-linux-amd64 demo
    ;;
    Darwin*)
      download
      ./offen-darwin-10.6-amd64 demo
    ;;
    *)
      if [[ $(command -v docker) ]]; then
        if [[ ! $(docker info) ]]; then
          echo "We tried to use Docker for your demo, but it seems it is currently not running."
          echo "Please start Docker on your system and try running this script again."
          exit 1
        fi
        pull
        docker run --rm -i -p 9876:9876 offen/offen:latest demo -port 9876
      else
        echo "Your operating system is currently not supported by this script."
        echo "You can try installing Docker and use the offen/offen image to run a demo."
        echo ""
        echo "$ docker run --rm -it -p 9876:9876 offen/offen:latest demo -port 9876"
      fi
  esac
}

run_demo "$(uname -s)"
