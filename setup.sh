#!/usr/bin/env bash
clear -x

# -------------------------------------------------------------------------------- #
# Set Bash Tools parameters and load them.                                         #
# -------------------------------------------------------------------------------- #

bt_term_width=120

if [[ $EUID = 0 ]]; then
    USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
else
    USER_HOME=$HOME
fi
source "$USER_HOME/bash_tools/bt_tools.sh"

# -------------------------------------------------------------------------------- #
# Load script language text based on Bash Tools selected language.                 #
# -------------------------------------------------------------------------------- #

myRootPath=$(readlink -m $(dirname "${BASH_SOURCE[0]}"))
source "${myRootPath}/languages/language.${bt_language}.sh"

# -------------------------------------------------------------------------------- #
# Install required package                                                         #
# -------------------------------------------------------------------------------- #

bt_check_package libxml2-utils

# -------------------------------------------------------------------------------- #
# Get actions to be performed                                                      #
# -------------------------------------------------------------------------------- #

do_get_actions_to_be_performed () {

    myWhiptailSelections=$(whiptail \
        --title "$wtActions" \
        --checklist \
        "\n$wmActions" \
        13 70 4 \
        "LANGUAGE" "$woSelA1" "OFF" \
        "MAME" "$woSelB1" $(git config --file "${myRootPath}/setup/setup.cfg" SETUP.MAME) \
        "ATTRACT" "$woSelB2" $(git config --file "${myRootPath}/setup/setup.cfg" SETUP.ATTRACT) \
        "ARCADEFLOW" "$woSelB3" $(git config --file "${myRootPath}/setup/setup.cfg" SETUP.ARCADEFLOW) \
        3>&1 1>&2 2>&3)
    [ $? != 0 ] && bt_script_cancel
    clear -x

    [[ -z $myWhiptailSelections ]] && bt_script_error "$bt_wh_no_selection"

    read -ra mySelection <<< $(echo ${myWhiptailSelections} | sed 's/"//g')

    # Setup language if requested
    if [[ $mySelection =~ "LANGUAGE" ]]; then
        bt_select_language
        bt_load_language $bt_language
        source "${myRootPath}/languages/language.${bt_language}.sh"
        mySelection=("${mySelection[@]:1}")
    fi
    mySoftwares=("${mySelection[@]}")

}

# -------------------------------------------------------------------------------- #
# Scripts steps.                                                                   #
# -------------------------------------------------------------------------------- #

mySoftwares=("ATTRACT")

#bt_display_banner "RPI 4 MAME,Setup" $bt_color_yellow
#do_get_actions_to_be_performed

# Loop to get latest softwares versions from Git
for mySoftware in ${mySoftwares[@]}; do

    bt_print_framed_title "${ln_setup_start}'$mySoftware'" $bt_color_yellow
    source "${myRootPath}/setup/setup.${mySoftware}.sh"

done

# -------------------------------------------------------------------------------- #
# End of script.                                                                   #
# -------------------------------------------------------------------------------- #

#clear -x
bt_print_framed_title "$ln_script_finished_successfully" $bt_color_yellow
exit 0
