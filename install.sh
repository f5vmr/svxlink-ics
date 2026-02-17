#!/bin/bash
#### INSTALLATION SCRIPT ####
# Setting non-superuser elements #
#### INITIALISE ####

source "${BASH_SOURCE%/*}/functions/initialise.sh"
initialise

cd /home/pi

# Log OS and user (screen + log)
echo -e "${GREEN} #### OS = $operating_system and Current user = $logname #### ${NORMAL}" | sudo tee -a /var/log/install.log 

#### SuperUser Install ####
#### LANGUAGE ####
source "${BASH_SOURCE%/*}/functions/language.sh"
which_language

# Run language-specific installer
case "$LANG" in
    
    en_US.UTF-8)
        sudo ./svxlinkbuilder/install_main.sh
        ;;
    en_GB.UTF-8)
        sudo ./svxlinkbuilder/install_main.sh  # Default UK English
        ;;
esac
