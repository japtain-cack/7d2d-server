#!/usr/bin/env bash

export REMCO_HOME=/etc/remco
export REMCO_RESOURCE_DIR=${REMCO_HOME}/resources.d
export REMCO_TEMPLATE_DIR=${REMCO_HOME}/templates

echo

sudo chown -R sevend2d:sevend2d ${SEVEND2D_HOME}

cat <<EOF> ${SEVEND2D_HOME}/sevend2d.conf
@ShutdownOnFailedCommand 1 //set to 0 if updating multiple servers at once
@NoPromptForPassword 1
force_install_dir ${SEVEND2D_HOME}/server/
login anonymous
app_update 294420
quit
EOF

./steamcmd.sh +runscript ${SEVEND2D_HOME}/sevend2d.conf

cd ${SEVEND2D_HOME}/server/
remco

echo
echo "#####################################"
echo starting server...
echo

./startserver.sh -configfile=serverconfig.xml

