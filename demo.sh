#! /bin/bash

set -eo pipefail

download () {
  echo "Downloading binaries into /tmp/offen-demo-$1 ..."
  mkdir -p /tmp/offen-demo-$1 && cd /tmp/offen-demo-$1
  curl -sSL https://get.offen.dev/latest | tar -xz
  echo ""
  echo "Verifying download checksums ..."
  command -v md5sum >/dev/null && md5sum -c checksums.txt
  echo ""
  echo "Done preparing. Next we'll be launching your demo."
}

pull () {
  echo ""
  echo "Using Docker ..."
  docker pull offen/offen:latest
}

run_demo () {
  case "$1" in
    Linux*)
      download $(date +"%s")
      ./offen-linux-amd64 demo
    ;;
    Darwin*)
      download $(date +"%s")
      ./offen-darwin-10.6-amd64 demo
    ;;
    *)
      if [ -x "$(command -v docker)" ]; then
        pull
        docker run --rm -it -p 9876:9876 offen/offen:latest demo -port 9876
      else
        echo "Your operating is currently not supported by this script."
        echo "You can try installing Docker and use the offen/offen image to run a demo."
        echo ""
        echo "$ docker run --rm -it -p 9876:9876 offen/offen:latest demo -port 9876"
      fi
  esac
}

run_demo $(uname -s)
