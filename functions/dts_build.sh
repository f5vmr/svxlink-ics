#!/bin/bash

################################
# DTS Overlay Builder
# Creates device tree overlay based on sound card selection
################################

dts_build() {
    local card_selection=$1
    local source_file
    
    # Validate input
    if [[ -z "$card_selection" ]]; then
        echo "Error: card_selection required" >&2
        return 1
    fi
    
    # Select appropriate expander file
    if [[ "$card_selection" == "1" ]] || [[ "$card_selection" == "2" ]]; then
        source_file="configs/expander.small.txt"
    elif [[ "$card_selection" == "4" ]]; then
        source_file="configs/expander.large.txt"
    else
        echo "Error: Invalid card selection: $card_selection" >&2
        return 1
    fi
    
    # Check if source file exists
    if [[ ! -f "$source_file" ]]; then
        echo "Error: Source file not found: $source_file" >&2
        return 1
    fi
    
    echo "Building DTS overlay for card type: $card_selection"
    echo "Using source file: $source_file"
    
    # Cat to temporary location
    cat "$source_file" > /tmp/ics-repeater.dts
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to write to /tmp/ics-repeater.dts" >&2
        return 1
    fi
    
    # Copy to /etc with sudo
    sudo cp /tmp/ics-repeater.dts /etc/ics-repeater.dts
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to copy to /etc/ics-repeater.dts" >&2
        return 1
    fi
    
    # Compile device tree blob
    echo "Compiling device tree blob..."
    sudo dtc -@ -I dts -O dtb -o /boot/overlays/ics-repeater.dtbo /etc/ics-repeater.dts
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to compile device tree blob" >&2
        return 1
    fi
    
    # Append overlay configuration to config.txt
    echo "Updating /boot/firmware/config.txt..."
    if [[ ! -f "/boot/firmware/config.txt" ]]; then
        echo "Error: /boot/firmware/config.txt not found" >&2
        return 1
    fi
    
    if [[ ! -f "configs/overlay.txt" ]]; then
        echo "Error: configs/overlay.txt not found" >&2
        return 1
    fi
    
    # Append overlay.txt to config.txt with sudo
    sudo bash -c "cat configs/overlay.txt >> /boot/firmware/config.txt"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to append to /boot/firmware/config.txt" >&2
        return 1
    fi
    
    echo "DTS overlay build completed successfully"
    return 0
}

# Call the function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    dts_build "$1"
fi
