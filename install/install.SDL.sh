#!/usr/bin/env bash

bt_print_message "Build dependencies..." $bt_color_yellow
sudo apt install build-essential -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Installing '$mySoftware' dependencies..." $bt_color_yellow
sudo apt install libfreetype6-dev libdrm-dev libgbm-dev libudev-dev libdbus-1-dev libasound2-dev liblzma-dev libjpeg-dev libtiff-dev libwebp-dev -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Installing OpenGL ES 2 dependencies..." $bt_color_yellow
sudo apt install libgles2-mesa-dev -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Configure Build..." $bt_color_yellow
cd "${myRootPath}/sources/${mySoftware}/${myZipName}"
mkdir -p build
rm -rf build/*
cd build
../configure --disable-video-opengl --disable-video-opengles1 --disable-video-x11 --disable-pulseaudio --disable-esd --disable-video-wayland --disable-video-rpi --disable-video-vulkan --enable-video-kmsdrm --enable-video-opengles2 --enable-alsa --disable-joystick-virtual --enable-arm-neon --enable-arm-simd
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'configure'"

bt_print_message "Build software..." $bt_color_yellow
[ $(uname -m) == "armv7l" ] && make -j $(nproc) CFLAGS='-mtune=cortex-a76 -mfpu=neon-fp-armv8 -mfloat-abi=hard'
[ $(uname -m) == "aarch64" ] && make -j $(nproc) CFLAGS='-mcpu=cortex-a76'
[ $(uname -m) == "x86_64" ] && make -j $(nproc)
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make'"

bt_print_message "Install software..." $bt_color_yellow
sudo make install
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make install'"

bt_print_message "Reload libraries..." $bt_color_yellow
sudo ldconfig -v
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'ldconfig'"

git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion $myGitVersion
