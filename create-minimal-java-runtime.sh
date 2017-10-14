#!/bin/sh

rm -fr target/openjdk-9-base_linux-x64

docker run --rm \
  --volume $PWD:/out \
  jdk-9-debian-slim \
  jlink --module-path /opt/jdk-9/jmods \
    --verbose \
    --add-modules java.base \
    --compress 2 \
    --no-header-files \
    --output /out/target/openjdk-9-base_linux-x64
