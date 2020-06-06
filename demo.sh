#! /bin/bash

set -eo pipefail

download () {
  echo "Downloading binaries into /tmp/offen-demo-$1 ..."
  mkdir -p /tmp/offen-demo-$1 && cd /tmp/offen-demo-$1
  curl -sSL https://get.offen.dev/latest | tar -xz
  if [ -x "$(command -v md5sum)" ]; then
    echo ""
    echo "Verifying download checksums ..."
    md5sum -c checksums.txt
  fi
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
        docker info > /dev/null 2>&1; ec=$?
        case $ec in
          0)
            pull
            docker run --rm -i -p 9876:9876 offen/offen:latest demo -port 9876
          ;;
          *)
            echo "We tried running the demo in Docker, but it seems it is currently not running."
            echo "Start Docker and try running this script again."
            ;;
        esac
      else
        echo "Your operating is currently not supported by this script."
        echo "You can try installing Docker and use the offen/offen image to run a demo."
        echo ""
        echo "$ docker run --rm -it -p 9876:9876 offen/offen:latest demo -port 9876"
      fi
  esac
}

run_demo $(uname -s)
