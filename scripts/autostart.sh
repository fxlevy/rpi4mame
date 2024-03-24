#!/bin/bash

# This script launch the selected application (front-end or MAME emulator) and respawn it if quit unexpectedly.

if [ ! -z $FRONTEND ]; then
  while
    case ${FRONTEND,,} in
    attract) # AttractPlus GUI
      /usr/local/bin/attractplus --loglevel silent >/dev/null 2>&1
      ;;
    mame) # MAME GUI
      /home/pi/rpi4mame/scripts/start.mame.sh
      ;;
    esac
    (($? != 0))
  do
    :
  done
else
  echo $0 - FRONTEND variable is not defined!
  read -n 1 -s -r -p 'Press any key to continue...'
  echo
fi
