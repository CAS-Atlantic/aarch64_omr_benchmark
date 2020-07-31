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
    if [[ -a /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq ]];
    then
        cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq | awk '{printf "%0.3lf GHz (Current CPU Frequency)\n", $1/1000.0}'

    elif [[ -a /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq ]];
    then
        cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq | awk '{printf "%0.3lf GHz (Current Scaling CPU Frequency)\n", $1/1000.0}'

    elif [[ -a /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_min_freq ]] && [[ -a /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq ]];
    then
        cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_min_freq | awk '{printf "%0.3lf GHz (Minimum CPU Frequency)\n", $1/1000.0}'
        cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq | awk '{printf "%0.3lf GHz (Maximum CPU Frequency)\n", $1/1000.0}'

    elif [[ -a /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq ]] && [[ -a /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq ]];
    then
        cat /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq | awk '{printf "%0.3lf GHz (Minimum Scaling CPU Frequency)\n", $1/1000.0}'
        cat /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq | awk '{printf "%0.3lf GHz (Maximum Scaling CPU Frequency)\n", $1/1000.0}'

    else
        echo -e "\nWARNING: Coudn't Determine Current or Minimum or Maximum or Scaling Current or Scaling Minimum or Scaling Maximum Frequency (/sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq and/or /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_min_freq and/or /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq and/or /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq and/or /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq and/or /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq doesn't exist!)!\n"
    fi

    echo -e "\n\n=============\nMEMORY:"
    egrep 'Swap|Mem' /proc/meminfo

    sleep 15

done
