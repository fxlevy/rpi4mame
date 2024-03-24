#!/usr/bin/env bash

bt_print_message "Build dependencies..." $bt_color_yellow
sudo apt install build-essential -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Installing '$mySoftware' dependencies..." $bt_color_yellow
sudo apt-get install fontconfig libfontconfig-dev libx11-dev libpulse-dev -y
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'apt install'"

bt_print_message "Installing swap manager..." $bt_color_yellow
sudo apt-get install dphys-swapfile -y

bt_print_message "Build software..." $bt_color_yellow
cd "${myRootPath}/sources/${mySoftware}/${myZipName}"
ARCHOPTS64='-march=armv8.2-a+crc+simd -mcpu=cortex-a76 -mtune=cortex-a76 -funsafe-math-optimizations -fprefetch-loop-arrays -fexpensive-optimizations'
MAKEOPTS='TARGETOS=linux NO_X11=1 NOWERROR=1 NO_USE_XINPUT=1 NO_USE_XINPUT_WII_LIGHTGUN_HACK=1 NO_OPENGL=1 USE_QTDEBUG=0 DEBUG=0 TOOLS=1 REGENIE=1 NO_BGFX=1 FORCE_DRC_C_BACKEND=1 NO_USE_PORTAUDIO=1 SYMBOLS=0'
MAXTHREAD=3
sudo systemctl stop dphys-swapfile.service
sudo systemctl start dphys-swapfile.service
make -j$MAXTHREAD ARCHOPTS="$ARCHOPTS64" $MAKEOPTS PLATFORM=arm64 PTR64=1
[ $? != 0 ] && bt_script_error "$bt_ln_UnixCommandError : 'make'"
sudo systemctl stop dphys-swapfile.service

git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion $myGitVersion

bt_print_message "Post install activities..." $bt_color_yellow

bt_set_environment_variable "SDL_VIDEODRIVER=kmsdrm"
bt_set_environment_variable "SDL_RENDER_DRIVER=opengles2"
bt_set_environment_variable "SDL_RENDER_VSYNC=1"
bt_set_environment_variable "SDL_GRAB_KEYBOARD=1"
bt_set_environment_variable "SDL_VIDEO_GLES2=1"

# Install MAME True-Type Liberation Sans font
if [ ! -d /usr/share/fonts/truetype/liberation-fonts ]; then
    echo Installing Liberation Sans font...
    cd ~
    wget -q http://dl.dafont.com/dl/?f=liberation_sans -O liberation_sans.zip
    if [ -f liberation_sans.zip ]; then
        sudo mkdir /usr/share/fonts/truetype/liberation-fonts
        sudo unzip -o /home/pi/liberation_sans.zip *.ttf -d /usr/share/fonts/truetype/liberation-fonts
        rm liberation_sans.zip
        sudo fc-cache -f -v
    fi
fi

# MAME binary symlink creation or update
if [ -L ~/mame ]; then rm ~/mame; fi
ln -s ${myRootPath}/sources/${mySoftware}/${myZipName} ~/mame
if [ -L /usr/local/bin/mame ]; then sudo rm /usr/local/bin/mame; fi
sudo ln -s ~/mame/mame /usr/local/bin/mame
