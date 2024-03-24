#!/usr/bin/env bash

################################################################################
# Selection Menu texts                                                         #
################################################################################
wtActions="Actions to be performed"
wmActions="Please select actions to be performed:"

################################################################################
# Selection Menu A : Install                                                   #
################################################################################
woSelA1="Change language"
woSelA2="Reset configuration"
woSelA3="SDL installation"
woSelA4="SDL TrueType Fonts installation"
woSelA5="MAME installation"
woSelA6="SFML installation"
woSelA7="Attract Mode+ installation"
woSelA8="Arcadeflow installation"

################################################################################
# Selection Menu B : Setup                                                     #
################################################################################
woSelB1="MAME Setup"
woSelB2="Attract Mode+ Setup"
woSelB3="Arcade Flow Setup"

################################################################################
# Reset choice                                                                 #
################################################################################
wtReset="Reset configuration"
wmReset="This activity will reset the software installation status.\nIt could be usefulll if a problem has occured previously and you want to restart from the beginning.\n\nDo you want to proceed?"

################################################################################
# Install script messages                                                      #
################################################################################
ln_get_software_version="Obtaining most recent softwares versions from their Git 'repo'."
ln_get_software_table_title="SOFTWARE      | LOCAL VERSION   | GIT VERSION     | UPDATE        |"
ln_download_software="Download softwares from their Git 'repo'."
ln_download_software_table_title="SOFTWARE      | GIT VERSION     | ZIP NAME                |"
ln_unzip_software="Unzip softwares."
ln_unzip_software_table_title="SOFTWARE      | ZIP NAME                | DESTINATION                              |"
ln_install_start="Starting script to install software : "
ln_script_finished_successfully="Procedure has finished successfully."
ln_script_attract_required="Attract Mode+ is not installed or not configured."

################################################################################
# Setup script messages                                                        #
################################################################################
ln_setup_start="Starting script to setup software :"
ln_setup_mame_done="MAME setup done."
ln_setup_attract_home_error="Execute attractplus once before executing this script."
