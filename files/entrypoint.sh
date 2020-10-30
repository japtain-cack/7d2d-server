#!/usr/bin/env bash

export REMCO_HOME=/etc/remco
export REMCO_RESOURCE_DIR=${REMCO_HOME}/resources.d
export REMCO_TEMPLATE_DIR=${REMCO_HOME}/templates

echo

sudo chown -R sevend2d:sevend2d ${SEVEND2D_HOME}

cat <<EOF> ${SEVEND2D_HOME}/sevend2d.conf
login anonymous
force_install_dir ${SEVEND2D_HOME}/server/
app_update 294420
quit
EOF

ls -la ${SEVEND2D_HOME}

which steamcmd

cat ${SEVEND2D_HOME}/sevend2d.conf | steamcmd

cd ${SEVEND2D_HOME}/server/7daysded
./startserver.sh

