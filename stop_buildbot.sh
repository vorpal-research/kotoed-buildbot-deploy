#!/usr/bin/env bash

cd $(dirname $(realpath $0))

source bin/activate

buildbot stop bb-master

for dir in bb-worker-*; do
	buildbot-worker stop $dir
done
