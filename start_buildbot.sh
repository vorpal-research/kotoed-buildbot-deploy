#!/usr/bin/env bash

source bin/activate

buildbot restart bb-master
buildbot-worker restart bb-worker
