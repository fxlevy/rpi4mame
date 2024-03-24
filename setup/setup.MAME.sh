#!/usr/bin/env bash

# -------------------------------------------------------------------------------- #
# Intitialize MAME Home directory.                                                 #
# -------------------------------------------------------------------------------- #

[[ -d $HOME/.mame ]] && rm -rf $HOME/.mame
mkdir $HOME/.mame
cd $HOME/.mame

# -------------------------------------------------------------------------------- #
# Generate ini files.                                                              #
# -------------------------------------------------------------------------------- #

myDataPath=$(git config --file "${myRootPath}/setup/setup.cfg" MAME.DataPath)
myTemplatesPath="${myRootPath}/templates/.mame"
myTargetPath="$HOME"

cp -r $myTemplatesPath $myTargetPath
find $myTargetPath/.mame -type f -exec sed -i "s/<datapath>/${myDataPath//\//\\\/}/g" {} +

bt_print_message "$ln_setup_mame_done" $bt_color_yellow
