#!/bin/bash

# This script launch the selected application (front-end or MAME emulator) and respawn it if quit unexpectedly.

if [ ! -z $FRONTEND ]; then
  while
    case ${FRONTEND,,} in
    attract) # AttractPlus Mode
      stty -echo
      /usr/local/bin/attractplus --loglevel silent >/dev/null 2>&1
      ;;
    mame) # MAME GUI or Automatic ROM Launch mode if AUTOROM is set
      /home/pi/mame/mame  >/dev/null 2>/dev/null
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
