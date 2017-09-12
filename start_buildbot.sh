#!/usr/bin/env bash

cd $(dirname $(realpath $0))

source bin/activate

buildbot restart bb-master
sleep 120
buildbot-worker restart bb-worker
