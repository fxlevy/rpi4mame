#!/usr/bin/env bash

bt_print_message "Build dependencies..." $bt_color_yellow
sudo apt install build-essential -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Installing '$mySoftware' dependencies..." $bt_color_yellow
sudo apt install libavutil-dev libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libswresample-dev libgl1-mesa-dev libglu1-mesa-dev
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Build software..." $bt_color_yellow
cd "${myRootPath}/sources/${mySoftware}/${myZipName}"
make clean
[ $(uname -m) == "aarch64" ] && make -j $(nproc) USE_DRM=1 USE_MMAL=1 USE_GLES=1
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make'"

bt_print_message "Install software..." $bt_color_yellow
sudo make install
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make install'"
sudo chmod -R 755 /usr/local/share/attract

git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion $myGitVersion
