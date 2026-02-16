#!/bin/sh
source "${BASH_SOURCE%/*}/functions/ics_welcome.sh"
ics_welcome

# Card selection
source functions/card_choice.sh
source functions/dts_build.sh

card_selection=$(card_choice)
if [[ $? -eq 0 ]]; then
    dts_build "$card_selection"
    if [[ $? -eq 0 ]]; then
        echo "Overlay setup complete"
    fi
fi
source functions/ics_complete.sh
ice_complete
