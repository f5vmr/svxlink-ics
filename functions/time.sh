#!/bin/bash
#function set timezone avoiding raspi-config
set_timezone() {

mapfile -t TZLIST < <(timedatectl list-timezones)

MENU=()
for tz in "${TZLIST[@]}"; do
    MENU+=("$tz" "")
done

TZ=$(whiptail --title "Timezone Setup" \
--menu "Select timezone" 20 70 12 \
"${MENU[@]}" \
3>&1 1>&2 2>&3)

[ -n "$TZ" ] && sudo timedatectl set-timezone "$TZ"

}