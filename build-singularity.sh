#!/bin/bash

set -xeu

export REPEAT_MASKER_VERSION=4.1.2-p1

docker build -t private/repeat-masker:${REPEAT_MASKER_VERSION} --build-arg REPEAT_MASKER_VERSION=${REPEAT_MASKER_VERSION} .
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/out:/output --privileged -t --rm quay.io/singularity/docker2singularity private/repeat-masker:${REPEAT_MASKER_VERSION}