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
# Get latest softwares git versions.                                               #
# -------------------------------------------------------------------------------- #

do_get_latest_softwares_versions_from_git() {

    # Get latest software version from Git
    myGitConfig=$1
    myGitUser=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.GitUser)
    myGitRepo=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.GitRepo)
    myLocalVersion=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.LocalVersion)
    bt_get_latest_software_version_from_git $myGitUser $myGitRepo
    git config --file "${myRootPath}/install/install.cfg" $myGitConfig.GitVersion $bt_git_version

    # Determine if software upate is required
    myGitVersion=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.GitVersion)
    if [[ $myGitVersion = $myLocalVersion ]]; then
        myUpdate=$bt_wh_no
        git config --file "${myRootPath}/install/install.cfg" INSTALL.$myGitConfig "NO"
    else
        myUpdate=$bt_wh_yes
        git config --file "${myRootPath}/install/install.cfg" INSTALL.$myGitConfig "YES"
    fi

    # Display result as a table row
    myPad="             "
    myGitRepo=$(printf "%s %s" "$myGitRepo" "$myPad" | cut -c 1-${#myPad})" | "
    myPad="               "
    myLocalVersion=$(printf "%s %s" "$myLocalVersion" "$myPad" | cut -c 1-${#myPad})" | "
    myPad="               "
    myGitVersion=$(printf "%s %s" "$myGitVersion" "$myPad" | cut -c 1-${#myPad})" | "
    myPad="             "
    myUpdate=$(printf "%s %s" "$myUpdate" "$myPad" | cut -c 1-${#myPad})" | "
    bt_print_framed_message "$myGitRepo$myLocalVersion$myGitVersion$myUpdate" $bt_color_yellow

}

do_get_latest_softwares_versions() {

    # Display table top border and column headers
    clear -x
    bt_print_framed_border $bt_color_yellow
    bt_print_framed_message "$ln_get_software_version" $bt_color_yellow
    bt_print_framed_border $bt_color_yellow "---------------+-----------------+-----------------+---------------+"
    bt_print_framed_message "$ln_get_software_table_title" $bt_color_yellow
    bt_print_framed_border $bt_color_yellow "---------------+-----------------+-----------------+---------------+"

    # Loop to get latest softwares versions from Git
    for mySoftware in ${mySoftwares[@]}; do
        do_get_latest_softwares_versions_from_git $mySoftware
    done

    # Display table bottom border
    bt_print_framed_border $bt_color_yellow "---------------+-----------------+-----------------+---------------+"
    bt_press_any_key_to_continue $bt_color_green

}

# -------------------------------------------------------------------------------- #
# Download software from Git.                                                     #
# -------------------------------------------------------------------------------- #

do_download_zip_sources_from_git() {

    # Get parameters
    myGitConfig=$1
    myGitUser=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.GitUser)
    myGitRepo=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.GitRepo)
    myGitVersion=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.GitVersion)
    myDownloadFolder="${myRootPath}/downloads/${myGitConfig}"

    bt_download_zip_source_from_git $myGitUser $myGitRepo $myGitVersion $myDownloadFolder
    git config --file "${myRootPath}/install/install.cfg" $myGitConfig.ZipName $bt_zip_name
    myZipName=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.ZipName)

    # Display result as a table row
    myPad="             "
    myGitRepo=$(printf "%s %s" "$myGitRepo" "$myPad" | cut -c 1-${#myPad})" | "
    myPad="               "
    myGitVersion=$(printf "%s %s" "$myGitVersion" "$myPad" | cut -c 1-${#myPad})" | "
    myPad="                       "
    myZipName=$(printf "%s %s" "$myZipName" "$myPad" | cut -c 1-${#myPad})" | "
    bt_print_framed_message "$myGitRepo$myGitVersion$myZipName" $bt_color_yellow

}

do_download_softwares() {

    # Display table top border and column headers
    clear -x
    bt_print_framed_border $bt_color_yellow
    bt_print_framed_message "$ln_download_software" $bt_color_yellow
    bt_print_framed_border $bt_color_yellow "---------------+-----------------+-------------------------+"
    bt_print_framed_message "$ln_download_software_table_title" $bt_color_yellow
    bt_print_framed_border $bt_color_yellow "---------------+-----------------+-------------------------+"

    # Loop to get latest softwares versions from Git
    for mySoftware in ${mySoftwares[@]}; do
        do_download_zip_sources_from_git $mySoftware
    done

    # Display table bottom border
    bt_print_framed_border $bt_color_yellow "---------------+-----------------+-------------------------+"
    sleep 2

}

# -------------------------------------------------------------------------------- #
# Unzip sources files.                                                             #
# -------------------------------------------------------------------------------- #

do_unzip_source() {

    # Get parameters
    myGitConfig=$1
    myZipName=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.ZipName)
    myZipFile="${myRootPath}/downloads/${myGitConfig}/${myZipName}.zip"
    myDestinationFolder="${myRootPath}/sources/${myGitConfig}"

    bt_unzip_file $myZipName $myZipFile $myDestinationFolder

    # Display result as a table row
    myPad="             "
    mySoftware=$(printf "%s %s" "$myGitConfig" "$myPad" | cut -c 1-${#myPad})" | "
    myPad="                       "
    myZipFile=$(printf "%s %s" "$myZipName" "$myPad" | cut -c 1-${#myPad})" | "
    myPad="                                        "
    myDestinationFolder=$(printf "%s %s" "$myDestinationFolder" "$myPad" | cut -c 1-${#myPad})" | "
    bt_print_framed_message "$mySoftware$myZipFile$myDestinationFolder" $bt_color_yellow

}

do_unzip_sources() {

    # Display table top border and column headers
    clear -x
    bt_print_framed_border $bt_color_yellow
    bt_print_framed_message "$ln_unzip_software" $bt_color_yellow
    bt_print_framed_border $bt_color_yellow "---------------+-------------------------+------------------------------------------+"
    bt_print_framed_message "$ln_unzip_software_table_title" $bt_color_yellow
    bt_print_framed_border $bt_color_yellow "---------------+-------------------------+------------------------------------------+"

    # Loop to unzip sources files
    for mySoftware in ${mySoftwares[@]}; do
        do_unzip_source $mySoftware
    done

    # Display table bottom border
    bt_print_framed_border $bt_color_yellow "---------------+-------------------------+------------------------------------------+"
    sleep 2

}

# -------------------------------------------------------------------------------- #
# Patch sources files.                                                             #
# -------------------------------------------------------------------------------- #

do_patch_source() {

    # Get parameters
    myGitConfig=$1
    myZipName=$(git config --file "${myRootPath}/install/install.cfg" $myGitConfig.ZipName)
    mySourceFolder="${myRootPath}/sources/${myGitConfig}/${myZipName}"
    myPatchFolder="${myRootPath}/patches/${myGitConfig}"

    # Check if patch files exist for software.
    ! [ -d "$myPatchFolder" ] && return
    ! [[ $(find "$myPatchFolder" -name "*.patch") ]] && return

    bt_print_framed_title "$ln_patch_source '$myGitConfig'" $bt_color_yellow

    for myPatchFile in $myPatchFolder/*.patch; do
        mySourceFile=$(cat $myPatchFile | grep '\-\-\-' | awk '{print $2}')
        mySourceFile=${mySourceFile:2}
        patch -r - -Ni $myPatchFile ${mySourceFolder}/${mySourceFile}
    done
    bt_print_framed_border $bt_color_yellow

}

do_patch_sources() {

    clear -x

    # Loop to patch sources
    for mySoftware in ${mySoftwares[@]}; do
        do_patch_source $mySoftware
    done
    sleep 2

}

# -------------------------------------------------------------------------------- #
# Get actions to be performed                                                      #
# -------------------------------------------------------------------------------- #

do_get_actions_to_be_performed() {

    # Determine if software upate is required
    for mySoftware in ${mySoftwares[@]}; do
        myGitVersion=$(git config --file "${myRootPath}/install/install.cfg" $mySoftware.GitVersion)
        myLocalVersion=$(git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion)
        if [[ $myGitVersion = $myLocalVersion ]]; then
            git config --file "${myRootPath}/install/install.cfg" INSTALL.$mySoftware "NO"
        else
            git config --file "${myRootPath}/install/install.cfg" INSTALL.$mySoftware "YES"
        fi
    done

    myWhiptailSelections=$(whiptail \
        --title "$wtActions" \
        --checklist \
        "\n$wmActions" \
        17 70 8 \
        "LANGUAGE" "$woSelA1" "OFF" \
        "RESET" "$woSelA2" "OFF" \
        "SDL" "$woSelA3" $(git config --file "${myRootPath}/install/install.cfg" INSTALL.SDL) \
        "TTF" "$woSelA4" $(git config --file "${myRootPath}/install/install.cfg" INSTALL.TTF) \
        "MAME" "$woSelA5" $(git config --file "${myRootPath}/install/install.cfg" INSTALL.MAME) \
        "SFML" "$woSelA6" $(git config --file "${myRootPath}/install/install.cfg" INSTALL.SFML) \
        "ATTRACT" "$woSelA7" $(git config --file "${myRootPath}/install/install.cfg" INSTALL.ATTRACT) \
        "ARCADEFLOW" "$woSelA8" $(git config --file "${myRootPath}/install/install.cfg" INSTALL.ARCADEFLOW) \
        3>&1 1>&2 2>&3)
    [ $? != 0 ] && bt_script_cancel
    clear -x

    [[ -z $myWhiptailSelections ]] && bt_script_error "$bt_wh_no_selection"

    read -ra mySelection <<<$(echo ${myWhiptailSelections} | sed 's/"//g')

    # Setup language if requested
    if [[ $mySelection =~ "LANGUAGE" ]]; then
        bt_select_language
        bt_load_language_texts $bt_language
        source "${myRootPath}/languages/language.${bt_language}.sh"
        mySelection=("${mySelection[@]:1}")
    fi
    mySoftwares=("${mySelection[@]}")

}

# -------------------------------------------------------------------------------- #
# Set language                                                                     #
# -------------------------------------------------------------------------------- #

do_set_language() {

    if [[ $mySelection =~ "LANGUAGE" ]]; then
        bt_select_language
        bt_load_language_texts $bt_language
        source "${myRootPath}/languages/language.${bt_language}.sh"
        mySelection=("${mySelection[@]:1}")
    fi
    mySoftwares=("${mySelection[@]}")

}

# -------------------------------------------------------------------------------- #
# Reset Config                                                                     #
# -------------------------------------------------------------------------------- #

do_reset_config() {

    if [[ $mySelection =~ "RESET" ]]; then
        whiptail \
            --title "$wtReset" \
            --yesno \
            "\n$wmReset" \
            --yes-button "$bt_wh_yes" \
            --no-button "$bt_wh_no" \
            16 70 \
            3>&1 1>&2 2>&3
        myWhChoice=$?
        [[ $myWhChoice > 1 ]] && bt_script_cancel

        clear -x

        if [[ $myWhChoice = 0 ]]; then
            cp ${myRootPath}/templates/install.cfg ${myRootPath}/install/install.cfg
            mySelection=("${mySelection[@]:1}")
        fi
    fi
    mySoftwares=("${mySelection[@]}")

}

do_get_software_paramaters() {

    myLocalVersion=$(git config --file "${myRootPath}/install/install.cfg" $mySoftware.LocalVersion)
    myGitVersion=$(git config --file "${myRootPath}/install/install.cfg" $mySoftware.GitVersion)
    myZipName=$(git config --file "${myRootPath}/install/install.cfg" $mySoftware.ZipName)

}

do_install_softwares() {

    for mySoftware in ${mySoftwares[@]}; do

        do_get_software_paramaters
        bt_print_framed_title "${ln_install_start}'$mySoftware'" $bt_color_yellow
        source "${myRootPath}/install/install.${mySoftware}.sh"

    done

}

# -------------------------------------------------------------------------------- #
# Scripts steps.                                                                   #
# -------------------------------------------------------------------------------- #

mySoftwares=("SDL" "TTF" " "MAME" "SFML" "ATTRACT" "ARCADEFLOW)
#mySoftwares=("ARCADEFLOW")

bt_display_banner "RPI 4 MAME,Install" $bt_color_yellow
do_get_latest_softwares_versions
do_get_actions_to_be_performed
do_set_language
do_reset_config
do_download_softwares
do_unzip_sources
do_patch_sources
bt_get_sudo_password
do_install_softwares

# -------------------------------------------------------------------------------- #
# End of script.                                                                   #
# -------------------------------------------------------------------------------- #

#clear -x
bt_print_framed_title "$ln_script_finished_successfully" $bt_color_yellow
exit 0
