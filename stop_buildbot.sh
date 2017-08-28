#!/usr/bin/env bash

cd $(dirname $(realpath $0))

source bin/activate

buildbot stop bb-master
buildbot-worker stop bb-worker
