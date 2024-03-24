#!/usr/bin/env bash

bt_print_message "Build dependencies..." $bt_color_yellow
sudo apt install build-essential -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Installing '$mySoftware' dependencies..." $bt_color_yellow
sudo apt install autogen libharfbuzz-dev -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

cd "${myRootPath}/sources/${mySoftware}/${myZipName}"
mkdir -p build
rm -rf build/*
cd build

bt_print_message "Configure Build..." $bt_color_yellow
../configure --enable-freetype-builtin=no --enable-harfbuzz-builtin=no
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'configure'"

bt_print_message "Build software..." $bt_color_yellow
[ $(uname -m) == "armv7l" ] && make -j $(nproc) CFLAGS='-mtune=cortex-a76 -mfpu=neon-fp-armv8 -mfloat-abi=hard'
[ $(uname -m) == "aarch64" ] && make -j $(nproc)
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make'"

bt_print_message "Install software..." $bt_color_yellow
sudo make install
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make install'"

bt_print_message "Reload libraries..." $bt_color_yellow
sudo ldconfig -v
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'ldconfig'"

git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion $myGitVersion
