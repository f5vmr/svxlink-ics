#!/bin/bash

################################
# Installation Complete Message
# Displays completion message and initiates reboot
################################

ics_complete() {
    whiptail --title "Overlay Installation Complete" --msgbox "The overlays are now complete.\n\nThe next stage will be:\n./svxlink/install.sh\n\nafter the system has reinitiated.\n\nThe system will now reboot." 14 60
    
    # Initiate reboot
    echo "Rebooting system..."
    sudo reboot
}

# Call the function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ics_complete
fi
