#!/usr/bin/env bash

source bin/activate

buildbot stop bb-master
buildbot-worker stop bb-worker
