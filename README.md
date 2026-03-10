# svxlink-ics
SvxLink for the ICS-ctrls cards - This software is in development - This software will not work on its own.

For more information email g4nab.ne63@gmail.com 

The 1X board is a single channel repeater or Simplex Node
The 2X board is a dual Channel Repeater/Simplex Board
The 4X board is a Quad Channel Repeater/Simplex Board

The ports are configured numerically 1 to 4 in the 4X board.
It is recommended that if you use 2 repeaters and two simplex unit, then you place the repeaters at port 1 & 2 and the simplex units at port 3 and 4.

If you have only one repeater and one simplex then use port 1 for the repeater and port 3 for the simplex.

If you intend to use 3 or 4 repeaters, then there will be editing to accomplish to accomodate them in the software.

**Fan Control**
In both the 1X and 2X you may use GPIO 5,6 and 22 to drive a relay control board, by taking these line to gate a transistor or other device.
In the 4X the RELAY1 and RELAY2 pins provide the gate voltage.
Software for the fan control is built-in, giving 10 seconds start delay and 20 seconds hysteresis when the PTT lines are discontinued.

The former ModuleTxFan in svxlink is deprecated.

+--------------------------------------------------+
|                  ICS Board 4-Port example        |
|--------------------------------------------------|
|  GPIO Expanders (MCP23017)                      |
|   - Core GPIOs @0x27: EN_1-4, TX_1-4, RX_1-4,  |
|     CT_1-4, etc.                                |
|   - Expansion GPIOs @0x26                       |
|   - Provides switching, enable/disable, relays |
|                                                  |
|  ADCs (ADS1015)                                 |
|   - RX ADC @0x48 → channels 0-3 (RX1-RX4)      |
|   - TX ADC @0x49 → channels 0-3 (TX1-TX4)      |
+--------------------------------------------------+
           | I2C
           v
+--------------------------------------------------+
| IIO Interface (Linux kernel driver)             |
|--------------------------------------------------|
| Exposes ADC channels as:                         |
| /sys/bus/iio/devices/iio:device0/in_voltage0_raw|
| … through device0 (RX)                          |
| /sys/bus/iio/devices/iio:device1/in_voltage0_raw|
| … through device1 (TX)                          |
+--------------------------------------------------+
           | Polled by Python ADC bridge
           v
+--------------------------------------------------+
| Python ADC Bridge                                |
|--------------------------------------------------|
| - Polls each ADC channel at ~16kHz              |
| - Converts raw counts → 16-bit PCM              |
| - Writes each channel to ALSA loopback          |
| - Controls GPIOs if needed via I2C MCP23017    |
+--------------------------------------------------+
           | ALSA hw:Loopback
           v
+--------------------------------------------------+
| ALSA Loopback Devices                            |
|--------------------------------------------------|
| RX1 → hw:Loopback,1,0                             |
| RX2 → hw:Loopback,1,1                             |
| RX3 → hw:Loopback,1,2                             |
| RX4 → hw:Loopback,1,3                             |
| TX1 → hw:Loopback,2,0                             |
| TX2 → hw:Loopback,2,1                             |
| TX3 → hw:Loopback,2,2                             |
| TX4 → hw:Loopback,2,3                             |
+--------------------------------------------------+
           | ALSA API
           v
+--------------------------------------------------+
|                     SvxLink                      |
|--------------------------------------------------|
| RX AUDIO_DEV=alsa:Loopback,1,0 (RX1)            |
| RX AUDIO_DEV=alsa:Loopback,1,1 (RX2)            |
| RX AUDIO_DEV=alsa:Loopback,1,2 (RX3)            |
| RX AUDIO_DEV=alsa:Loopback,1,3 (RX4)            |
| TX AUDIO_DEV=alsa:Loopback,2,0 (TX1)            |
| TX AUDIO_DEV=alsa:Loopback,2,1 (TX2)            |
| TX AUDIO_DEV=alsa:Loopback,2,2 (TX3)            |
| TX AUDIO_DEV=alsa:Loopback,2,3 (TX4)            |
| GPIO control handled via MCP23017 if needed     |
+--------------------------------------------------+

