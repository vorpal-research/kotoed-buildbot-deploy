#!/usr/bin/env bash

cd $(dirname $(realpath $0))

source bin/activate

buildbot restart bb-master || exit 1
buildbot-worker restart bb-worker || exit 1
