#!/usr/bin/env bash

cd $(dirname $(realpath $0))

source bin/activate

buildbot restart bb-master

sleep 240

for dir in bb-worker-*; do
	buildbot-worker restart $dir
done
