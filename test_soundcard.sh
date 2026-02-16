#!/bin/bash
##### USB SOUND CARD ####
#
#source "${BASH_SOURCE%/*}/functions/sound_card.sh"
#soundcard
##### NODE Selection ####
#source "${BASH_SOURCE%/*}/functions/node_type.sh"
#nodeoption
#echo -e "$(date)" "${YELLOW} #### Node Type: $NODEOPTION #### ${NORMAL}" | sudo tee -a /var/log/install.log
#
#echo -e "$(date)" "${YELLOW} #### Sound Card: $HID $GPIOD $card #### ${NORMAL}" | sudo tee -a /var/log/install.log 
#echo -e "$(date)" "${YELLOW} #### Checking Alsa #### ${NORMAL}" | sudo tee -a /var/log/install.log 
sound_cards=$(cat /proc/asound/cards)
echo $sound_cards | grep -q 'wm8960soundcard'
if [ $? -eq 0 ]; then
    echo "WM8960 sound card detected:" 
else
    echo "WM8960 sound card not detected."
fi

