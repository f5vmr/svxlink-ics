#!/bin/bash
#function set timezone avoiding raspi-config
set_timezone() {

TZ=$(timedatectl list-timezones | \
whiptail --title "Select Timezone" \
--menu "Choose your timezone" 20 60 10 \
$(timedatectl list-timezones | awk '{print $1 " " ""}') \
3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    sudo timedatectl set-timezone "$TZ"
    whiptail --msgbox "Timezone set to $TZ" 8 40
fi

}