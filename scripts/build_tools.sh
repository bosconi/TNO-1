#!/bin/bash
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is required. this should be 2nd line of script.
# Above line makes this script ignore Windows line endings, to avoid this error without having to run dos2unix: 
#    $'\r': command not found
# As per http://stackoverflow.com/questions/14598753/running-bash-script-in-cygwin-on-windows-7

# Configure environment variables etc
source ./scripts/env.sh

DATAGEN_SRC_ROOT=tno/tno/src/java
DATAGEN_SRC_PATH=tno/tno/src/java/com/microsoft/research/tno/tools/datagen/
DATAGEN_BIN_PATH=../../bin

# For now, use the Java compiler directly instead of configuring ant etc.
JDK_BIN_PATH=${JAVA_HOME}/bin
if [ ! -e "${JDK_BIN_PATH}/javac.exe" ]; then
  echo Cannot find javac.exe at ${JDK_BIN_PATH}. Check Java is installed there ...
  exit 1
fi

export PATH=${JDK_BIN_PATH}:${PATH}

pushd ${DATAGEN_SRC_PATH}
javac DataGenTool.java
popd

pushd ${DATAGEN_SRC_ROOT}
# Need to include DataGenTool*.class because of the enum switch helper class generated by javac, as per
# https://developer.opencloud.com/forum/posts/list/248.page
# Specify the main class via e flag, to save creating a manifest.txt
# as per http://stackoverflow.com/questions/2591516/why-has-it-failed-to-load-main-class-manifest-attribute-from-a-jar-file
jar cfe ${DATAGEN_BIN_PATH}/DataGenTool.jar com.microsoft.research.tno.tools.datagen.DataGenTool com/microsoft/research/tno/tools/datagen/DataGenTool*.class
popd
