#!/usr/bin/env python3
import alsaaudio, time, gpiod

### Script to activate ADC Lines
CHIP = "gpiochip3"
LINE = 11
chip = gpiod.Chip(CHIP)
line = chip.get_line(LINE)
line.request(
    consumer="ads1015-enable",
    type=gpiod.LINE_REQ_DIR_OUT,
    default_vals=[1]   # HIGH = ADC enabled
)
print("ADS1015 enabled (GPIO HIGH)")
### script to configure adc to alsa
# Map IIO channels to ALSA subdevices
channels = [
    # RX channels 1-4
    {'iio':'/sys/bus/iio/devices/iio:device0/in_voltage0_raw', 'alsa':'hw:Loopback,1,0'},
    {'iio':'/sys/bus/iio/devices/iio:device0/in_voltage1_raw', 'alsa':'hw:Loopback,1,1'},
    {'iio':'/sys/bus/iio/devices/iio:device0/in_voltage2_raw', 'alsa':'hw:Loopback,1,2'},
    {'iio':'/sys/bus/iio/devices/iio:device0/in_voltage3_raw', 'alsa':'hw:Loopback,1,2'},
    # TX channels 5-8
    {'iio':'/sys/bus/iio/devices/iio:device1/in_voltage0_raw', 'alsa':'hw:Loopback,2,0'},
    {'iio':'/sys/bus/iio/devices/iio:device1/in_voltage1_raw', 'alsa':'hw:Loopback,2,1'},
    {'iio':'/sys/bus/iio/devices/iio:device1/in_voltage2_raw', 'alsa':'hw:Loopback,2,2'},
    {'iio':'/sys/bus/iio/devices/iio:device1/in_voltage3_raw', 'alsa':'hw:Loopback,2,3'},
]

# Open ALSA devices
alsa_outs = {}
for c in channels:
    if c['alsa'] not in alsa_outs:
        out = alsaaudio.PCM(type=alsaaudio.PCM_PLAYBACK, device=c['alsa'])
        out.setchannels(1)
        out.setrate(8000)
        out.setformat(alsaaudio.PCM_FORMAT_S16_LE)
        alsa_outs[c['alsa']] = out

while True:
    for ch in channels:
        with open(ch['iio']) as f:
            raw = int(f.read().strip())
        pcm = ((raw / 4095.0) * 32767).to_bytes(2, 'little', signed=True)
        alsa_outs[ch['alsa']].write(pcm)
    time.sleep(1/8000)  # 8 kHz
    