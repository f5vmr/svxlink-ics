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


