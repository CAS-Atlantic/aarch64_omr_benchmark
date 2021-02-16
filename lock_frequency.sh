#!/bin/bash
# Authors: Aaron Graham (aaron.graham@unb.ca, aarongraham9@gmail.com) and
#          Jean-Philippe Legault (jlegault@unb.ca, jeanphilippe.legault@gmail.com)
#           for the Centre for Advanced Studies - Atlantic (CAS-Atlantic) at the
#            Univerity of New Brunswick in Fredericton, New Brunswick, Canada

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi
if [ "_$1" = "_" ]; then
    echo "This script expect a frequency, i.e. 1.28 etc..."
    exit 1
fi

cpupower frequency-set -g userspace
cpupower frequency-set -u $1GHz
cpupower frequency-set -d $1GHz
cpupower frequency-set -f $1GHz
