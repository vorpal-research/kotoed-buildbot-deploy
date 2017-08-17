#!/usr/bin/env bash

source bin/activate

buildbot restart bb-master || exit 1
buildbot-worker restart bb-worker || exit 1
