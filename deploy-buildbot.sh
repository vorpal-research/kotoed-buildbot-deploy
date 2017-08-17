#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BUILDBOT_ROOT_DIR=${1?"Buildbot root dir missing"}
BUILDBOT_WORKER_NAME=${2?"Buildbot worker name missing"}
BUILDBOT_WORKER_PWD=${3?"Buildbot worker password missing"}

if [[ ! -e "id_rsa.kotoed" ]]; then
	echo "id_rsa.kotoed is missing"
	exit 1
fi

if [[ ! -e "id_rsa.kotoed.pub" ]]; then
	echo "id_rsa.kotoed.pub is missing"
	exit 1
fi

mkdir -p "${BUILDBOT_ROOT_DIR}"
cd "${BUILDBOT_ROOT_DIR}"

virtualenv .
source bin/activate

pip install buildbot[bundle]
pip install -e hg+https://bitbucket.org/vorpal-research/buildbot-dynamic#egg=buildbot-dynamic

buildbot create-master -r bb-master
buildbot-worker create-worker bb-worker localhost:9989 "${BUILDBOT_WORKER_NAME}" "${BUILDBOT_WORKER_PWD}"

cp -u "${SCRIPT_DIR}/master.cfg" bb-master
cp -u "${SCRIPT_DIR}/688b3917ff347813631c24e0ebdd3c67.json" bb-master

mkdir -p bb-master/secrets
cp -u "${SCRIPT_DIR}/id_rsa.kotoed" bb-master/secrets
cp -u "${SCRIPT_DIR}/id_rsa.kotoed.pub" bb-master/secrets
chmod 600 bb-master/secrets/*

sed -i "s/BUILDBOT_WORKER_NAME/${BUILDBOT_WORKER_NAME}/g" bb-master/master.cfg
sed -i "s/BUILDBOT_WORKER_PWD/${BUILDBOT_WORKER_PWD}/g" bb-master/master.cfg

patch bb-worker/buildbot.tac "${SCRIPT_DIR}/buildbot.tac.patch"

cp -u "${SCRIPT_DIR}/start_buildbot.sh" .
cp -u "${SCRIPT_DIR}/stop_buildbot.sh" .
