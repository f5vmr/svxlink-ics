#!/bin/bash

################################
# ICS Welcome Screen
# Displays whiptail introduction for ICS Svxlink installation
################################

ics_welcome() {
    whiptail --title "Welcome" --msgbox "ICS-ctrl.com SvxLink installation\n\nWelcome to the ICS Svxlink installation wizard.\n\nThis installer will guide you through the setup process." 12 60
}

# Call the function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ics_welcome
fi
