#!/bin/bash

#
# Copyright (C) 2021 ez-Wheel S.A.S.
#

source /opt/ezw/lib/functions.res
export LD_LIBRARY_PATH=$EZUSRLIB

# Go
ZFILE="$EZUSRLOG/sce-swd-left.log"
case "$1" in
"start")
  NOW=$(date +"%Y-%m-%d %T")
  $ECHO "##########################" >>$ZFILE
  $ECHO "Starting Release Version : ${CURRENT_RELEASE}" >>$ZFILE
  $ECHO "$NOW" >>$ZFILE
  $ECHO "##########################" >>$ZFILE

  #############################################################
  #load variables from file ..
  #############################################################
  $ECHO ""
  $PRIN "%-80.80s" "loading ini variables ... "
  $PRIN "%-80.80s" "loading ini variables ... " >>$ZFILE
  #load_ini_vars
  if [ $? -eq 0 ]; then
    echo_success
    $ECHO " OK " >>$ZFILE
  else
    echo_failure
    $ECHO " KO " >>$ZFILE
  fi

  global_equipment_type=ROBOT
  case $global_equipment_type in
  "ROBOT")
    $ECHO "Run on $global_equipment_type With Role Master $global_ismaster : Starting $DRIV_SMC_ROBOT"
    $ECHO "Run on $global_equipment_type With Role Master $global_ismaster : Starting $DRIV_SMC_ROBOT" >>$ZFILE
    load_dbus 1>>$ZFILE 2>&1
    launch "$SWD_LEFT" $ZFILE
    returnval=$?
    ;;
  *)
    $ECHO "Not Starting on unknown target (default)"
    $ECHO "Not Starting on unknown target (default)" >>$ZFILE
    returnval=$OK
    ;;
  esac
  ;;
esac
exit $returnval
