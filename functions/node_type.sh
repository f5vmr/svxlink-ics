#!/bin/bash
node=""
function nodeoption {
    #!/bin/bash

# Read number of physical ports from config (valid: 1, 2, 4)
NUM_PORTS=$(grep -E "^ports=" /etc/ics-repeater.conf | cut -d'=' -f2)

# Sanity check
case "$NUM_PORTS" in
    1|2|4) ;;
    *)
        echo "Unsupported ICS card port count: $NUM_PORTS" >&2
        exit 1
        ;;
esac

NODE_TYPES=()
SVXREFLECTOR=()

function nodeoption {

    echo "ICS card reports $NUM_PORTS physical ports" \
        | sudo tee -a /var/log/install.log

    # Build dynamic menu for number of ports to configure
    MENU_ITEMS=()
    for ((i=1; i<=NUM_PORTS; i++)); do
        MENU_ITEMS+=("$i" "Configure $i port(s)")
    done

    PORTS_TO_CONFIGURE=$(whiptail \
        --title "SvxLink Port Configuration" \
        --menu "How many ports do you want to configure?" \
        15 60 "$NUM_PORTS" \
        "${MENU_ITEMS[@]}" \
        3>&1 1>&2 2>&3)

    [ -z "$PORTS_TO_CONFIGURE" ] && exit 1

    # Configure selected ports
    for ((i=1; i<=PORTS_TO_CONFIGURE; i++)); do

        TYPE=$(whiptail \
            --title "Port $i Node Type" \
            --menu "Select node type for Port $i" \
            15 60 2 \
            "Simplex" "Simplex node" \
            "Repeater" "Repeater node" \
            3>&1 1>&2 2>&3)

        [ -z "$TYPE" ] && exit 1
        NODE_TYPES+=("$TYPE")

        REFLECTOR=$(whiptail \
            --title "Port $i SvxReflector" \
            --menu "SvxReflector for Port $i?" \
            15 60 2 \
            "No" "Without SvxReflector" \
            "Yes" "With SvxReflector" \
            3>&1 1>&2 2>&3)

        [ -z "$REFLECTOR" ] && exit 1
        SVXREFLECTOR+=("$REFLECTOR")

        echo "Port $i: $TYPE, SvxReflector=$REFLECTOR" \
            | sudo tee -a /var/log/install.log
    done

    # Mark unused physical ports
    for ((i=PORTS_TO_CONFIGURE+1; i<=NUM_PORTS; i++)); do
        NODE_TYPES+=("Unconfigured")
        SVXREFLECTOR+=("No")
        echo "Port $i: Unconfigured" \
            | sudo tee -a /var/log/install.log
    done

    # Track required logic modules
    USE_SIMPLEX_LOGIC=0
    USE_REPEATER_LOGIC=0

    for t in "${NODE_TYPES[@]}"; do
        [ "$t" = "Simplex" ] && USE_SIMPLEX_LOGIC=1
        [ "$t" = "Repeater" ] && USE_REPEATER_LOGIC=1
    done

    export NODE_TYPES
    export SVXREFLECTOR
    export USE_SIMPLEX_LOGIC
    export USE_REPEATER_LOGIC

    echo "Logic enabled: Simplex=$USE_SIMPLEX_LOGIC Repeater=$USE_REPEATER_LOGIC" \
        | sudo tee -a /var/log/install.log
}
##    if [ "$LOGIC_MODULE" = "SimplexLogic" ]; then
##        NOT_LOGIC_MODULE="RepeaterLogic"
##    else
##        NOT_LOGIC_MODULE="SimplexLogic"
##    fi
##
##export NOT_LOGIC_MODULE
##
##
##echo "The logic module $NOT_LOGIC_MODULE will be removed from svxlink.conf" | sudo tee -a /var/log/install.log > /dev/null
##export LOGIC_MODULE
##echo "Using logic module: $LOGIC_MODULE" | sudo tee -a /var/log/install.log > /dev/null
##export NODE_OPTION; 
##}

