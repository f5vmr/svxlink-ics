#!/bin/bash
function soundcard {

# Check the sound cards present
sound_cards=$(cat /proc/asound/cards)

# Initialize variables to identify sound card types
#usb_sound_card_detected=false
#seeed_sound_card_detected=false
#wm8960_sound_card_detected=false
#other_sound_card_detected=false
#fepi_sound_card_detected=false


# Check for Fe-Pi / ICS repeater sound card
if echo "$sound_cards" | grep -Eq 'Fe-Pi|FePi|sndrpihifiberry|HifiBerry'; then
    echo "Fe-Pi / ICS sound card detected:" | sudo tee -a /var/log/install.log > /dev/null
    echo "$sound_cards" | grep -E 'Fe-Pi|FePi|sndrpihifiberry|HifiBerry'
    Fe-Pi_sound_card_detected
fi
if echo "$sound_cards" | grep -Eq 'TosLink|MCHStreamer|I2S'; then
    echo "Toslink sound card detected:" | sudo tee -a /var/log/install.log > /dev/null
    echo "$sound_cards" | grep -E 'TosLink|MCHStreamer|I2S'
    TosLink_sound_card_detected
fi
# Check for any other sound cards not explicitly identified by name and not Loopback
if echo "$sound_cards" | grep -q '[0-9] \[' && ! echo "$sound_cards" | grep -q 'Loopback' && ! $usb_sound_card_detected && ! $seeed_sound_card_detected; then
    echo "Other sound card detected:" | sudo tee -a /var/log/install.log > /dev/null
    echo "$sound_cards" | grep -v 'Loopback' 
    other_sound_card_detected
fi

}
## Print the assigned variable value
function Fe-Pi_sound_card_detected {
    if card_choice=1
    then
    card="Fe-Pi 1X Card"
    txgpiochip=3
    ptt_gpiod_line=10
    rxgpiochip=0
    sql_gpiod_line=26
    ctcss_gpiod_line=24
    elseif card_choice=2
    then
    card="Fe-Pi 2X Card"
    tx_gpiochip=3
    ptt_gpiod_line1=10
    ptt_gpiod_line2=11
    rx_gpiochip=0
    sql_gpiod_line1=26
    sql_gpiod_line2=23
    elseif card_choice=3
    then
    card="Toslink 4X Card"
    tx_gpiochip=3
}
function TosLink_sound_card_detected {
    card="Toslink 4X Card"
    tx_gpiochip=3
    rx_gpiochip=3
    ptt_gpiod_line1=TX_1
    ptt_gpiod_line2=TX_2
    ptt_gpiod_line3=TX_3
    ptt_gpiod_line4=TX_4
    sql_gpiod_line1=RX_1
    sql_gpiod_line2=RX_2
    sql_gpiod_line3=RX_3
    sql_gpiod_line4=RX_4

}
function usb_sound_card_detected {
echo "Variable assigned: $sound_card_variable"

    SOUND_OPTION=$(whiptail --title "USB Soundcard" --menu "Select from the options below." 12 78 4 \
        "1" "Fully Modified for Transmit and Receive (UDEV only)" \
        "2" "Fully Modified for Transmit Only (UDEV Tx & GPIOD Rx)" \
        "3" "Unmodified (use the GPIOD to control both Squelch and PTT )" 3>&1 1>&2 2>&3)      
    if [[ "$SOUND_OPTION" = "1" ]] 
    then
    HID=true
    GPIOD=false
    card=true
    ## No need to play with the GPIOD
    elif [[ "$SOUND_OPTION" = "2" ]] 
    then
    HID=true
    GPIOD=true
    card=true
    ## still need to set the HID for Transmit
    elif [[ "$SOUND_OPTION" = "3" ]] 
    then
    HID=false
    GPIOD=true
    card=false
    ## still need to set GPIOD for Transmit and Receive
    else
    echo "Invalid option"
    fi
    echo "HID is set to $HID"
    echo "GPIOD is set to $GPIOD"
    if [[ "$HID" = true ]] 
    then 
#### updates the udev rules for the USB sound card ####
    if [[ "$card" = true ]] 
    then
    echo "Ok, Let's add the updated rules"
               sudo cp /home/pi/svxlinkbuilder/addons/cm-108.rules /etc/udev/rules.d/
               sudo udevadm control --reload-rules
               sudo udevadm trigger
                
    else
    echo "ok, then I will make no other changes"           
    fi 
fi
    echo -e "$(date)" "${GREEN}Audio Updates including Dummy Sound Card for a web socket.${NORMAL}" | sudo tee -a /var/log/install.log 

    plughw_setting="0"
    channel_setting="0"
}


function  other_sound_card_detected {
HID=false
GPIOD=true
card=true
plughw_setting="0"
channel_setting="0"
}
function no_sound_card_detected {
HID=false
GPIOD=false
card=false				
plughw_setting="0"
channel_setting="0"
}