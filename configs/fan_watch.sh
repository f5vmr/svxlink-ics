#!/bin/sh

CONF="/etc/ics-repeater.conf"
TEMPLATE="fan_watch.py.in"
OUT="/usr/local/bin/fan_watch.py"

BOARD_TYPE=$(sed -n 's/^[[:space:]]*BOARD_TYPE[[:space:]]*=[[:space:]]*//p' "$CONF")

case "$BOARD_TYPE" in
    1|2)
        GPIO_CHIP="gpiochip0"
        GPIO_LINES="[5, 6, 22]"
        ;;
    3)
        GPIO_CHIP="gpiochip3"
        GPIO_LINES="[8, 9]"
        ;;
    *)
        echo "Unknown BOARD_TYPE: $BOARD_TYPE"
        exit 1
        ;;
esac

sed \
  -e "s/__GPIO_CHIP__/${GPIO_CHIP}/" \
  -e "s/__GPIO_LINES__/${GPIO_LINES}/" \
  "$TEMPLATE" > "$OUT"

chmod +x "$OUT"
