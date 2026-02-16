#!/bin/bash

################################
# Card Choice Selection
# Displays whiptail menu for selecting sound card type
################################

card_choice() {
    local choice
    choice=$(whiptail --title "Sound Card Selection" --menu "Select your sound card type:" 12 60 3 \
        "1" "1X Single Port Card" \
        "2" "2X Dual Port Card" \
        "4" "4XFour Port Card" \
        3>&1 1>&2 2>&3)
    
    local exit_status=$?
    
    if [[ $exit_status -eq 0 ]]; then
        echo "$choice"
        return 0
    else
        return 1
    fi
}

# Call the function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    card_choice
fi
