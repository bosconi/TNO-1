#!/bin/bash
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is required. this should be 2nd line of script.
# Above line makes this script ignore Windows line endings, to avoid this error without having to run dos2unix: 
#    $'\r': command not found
# As per http://stackoverflow.com/questions/14598753/running-bash-script-in-cygwin-on-windows-7

COLLECTION_NAME=collection1
SOLR_DIST_PATH=../../solr-4.6.1-tno/solr/dist
SOLR_DEPLOYMENT_PATH=solr_deployment

# Currently just one (optional) argument: 'debug', which enables the Java debugger.
DEBUG_FLAGS=
if [ "$#" -eq 1 ]; then
  if [ "$1" == "debug" ]; then
    DEBUG_FLAGS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5901"
  else
    echo "Only (optional) argument is 'debug'. Exiting ..."
	exit 1
  fi
fi

echo
echo "**** Trust No One demo v1.1 ****"
echo

echo Updating Solr WAR file...
[ ! -d ${SOLR_DEPLOYMENT_PATH}/webapps ] && mkdir ${SOLR_DEPLOYMENT_PATH}/webapps
cp ${SOLR_DIST_PATH}/solr-4.6-SNAPSHOT.war ${SOLR_DEPLOYMENT_PATH}/webapps/solr.war

echo Deleting existing indexes...
rm -rf ${SOLR_DEPLOYMENT_PATH}/solr/${COLLECTION_NAME}/data

echo Deleting TNO keys file...
rm -f ${SOLR_DEPLOYMENT_PATH}/SecureCipherUtil.Keys.txt

echo Deleting log files in example\logs...
rm -f ${SOLR_DEPLOYMENT_PATH}/logs/*

echo
echo Starting Solr...
( pushd ${SOLR_DEPLOYMENT_PATH} && java ${DEBUG_FLAGS} -jar start.jar )
