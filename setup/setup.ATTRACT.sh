#!/usr/bin/env bash

# -------------------------------------------------------------------------------- #
# Check Attrract Mode Home directory.                                              #
# -------------------------------------------------------------------------------- #

if [[ -d $HOME/.attract ]]; then
    bt_script_error "$ln_setup_attract_home_error"
fi
