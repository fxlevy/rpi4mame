#!/usr/bin/env bash

bt_print_message "Build dependencies..." $bt_color_yellow
sudo apt install build-essential cmake -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Installing '$mySoftware' dependencies..." $bt_color_yellow
sudo apt install libxrandr-dev libxcursor-dev libudev-dev libfreetype-dev libopenal-dev libflac-dev libvorbis-dev libgl1-mesa-dev libegl1-mesa-dev -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

cd "${myRootPath}/sources/${mySoftware}/${myZipName}"
mkdir -p build
rm -rf build/*
cd build

bt_print_message "Configure Build..." $bt_color_yellow
cmake .. -DSFML_OPENGL_ES=TRUE -DSFML_USE_DRM=TRUE
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'configure'"

bt_print_message "Build software..." $bt_color_yellow
[ $(uname -m) == "armv7l" ] && make -j $(nproc) CFLAGS='-mtune=cortex-a76 -mfpu=neon-fp-armv8 -mfloat-abi=hard'
[ $(uname -m) == "aarch64" ] && make -j $(nproc) CFLAGS='-mtune=cortex-a76'
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make'"

bt_print_message "Install software..." $bt_color_yellow
sudo make install
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make install'"

bt_print_message "Reload libraries..." $bt_color_yellow
sudo ldconfig -v
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'ldconfig'"

git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion $myGitVersion
