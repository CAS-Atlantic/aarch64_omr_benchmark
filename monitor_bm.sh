#!/bin/bash

while true
do
    clear

previous_temp="0"
for temps in /sys/class/thermal/thermal_zone*
do
    previous_temp=$( echo $(printf "${previous_temp} ") $(cat ${temps}/temp) | awk '{ if ( $1 > $2 ) printf "%d", $1; else printf "%d", $2}')
done
echo -e "MAX_TEMP: $( echo ${previous_temp} | awk '{printf "%0.3lf", $1/1000.0}')  \xe2\x84\x83"

echo ""
cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq | awk '{printf "%0.3lf GHz\n", $1/1000.0}'
echo -e "\n\n=============\nMEMORY:"
egrep 'Swap|Mem' /proc/meminfo

    sleep 15

done