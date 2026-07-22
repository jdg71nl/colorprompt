#!/usr/bin/env bash
#= 

cat <<EOF

> vcgencmd pmic_read_adc BATT_V
BATT_V volt(25)=2.72392900V

> cat /sys/class/rtc/rtc0/battery_voltage
2723929

#: d260722 Claude says:
# if you are using the official Raspberry Pi RTC battery (or another rechargeable battery like an LIR2032/ML621), you must enable trickle charging manually—it is disabled by default.
# > sudo vi /boot/firmware/config.txt
dtparam=rtc_bbat_vchg=3000000
#.

EOF

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

