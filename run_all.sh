#!/bin/bash
# Authors: Aaron Graham (aaron.graham@unb.ca, aarongraham9@gmail.com) and
#          Jean-Philippe Legault (jlegault@unb.ca, jeanphilippe.legault@gmail.com)
#           for the Centre for Advanced Studies - Atlantic (CAS-Atlantic) at the
#            Univerity of New Brunswick in Fredericton, New Brunswick, Canada

echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): Init:"

OPT_JDKS_PATTERN="/opt/jdk*/*/bin/java"
OPT_JDKS=( $OPT_JDKS_PATTERN )
# Grab First Found JDK in /opt/jdk*/ Directory:
OPT_JDK="${OPT_JDKS[0]}"

# Set JAVA_ROOT from Command Line Argument:
if [[ "" != $1 ]] && [[ -a "$1/bin/java" ]];
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): INFO: Setting JDK from Command-Line Argument (\$1: '$1').\n"
	JAVA_ROOT="$1"

# Make Sure an /opt/jdk*/ Directory Exists and an /opt/jdk*/*/bin/java Executable Exists:
elif [[ -d "`echo $OPT_JDK | sed -e 's#/bin/java$##'`" ]] && [[ -a "$OPT_JDK" ]];
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): WARNING: Setting JDK from Fisrt Found JDK in /opt/jdk*/ Directory (echo \$OPT_JDK | sed -e 's#/bin/java\$##': '`echo $OPT_JDK | sed -e 's#/bin/java$##'`').\n"
	JAVA_ROOT=`echo $OPT_JDK | sed -e 's#/bin/java$##'`

# Get JDK from JDK_HOME
elif [[ "" != "$JDK_HOME" ]] && [[ -a "$JDK_HOME/bin/java" ]];
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): WARNING: Setting JDK from JDK_HOME (JDK_HOME: '$JDK_HOME').\n"
	JAVA_ROOT="$JDK_HOME"

# Get JDK from JAVA_HOME
elif [[ "" != "$JAVA_HOME" ]] && [[ -a "$JAVA_HOME/bin/java" ]];
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): WARNING: Setting JDK from JAVA_HOME (JAVA_HOME: '$JAVA_HOME').\n"
	JAVA_ROOT="$JAVA_HOME"

# Get JDK from PATH
elif [[ "" != "$PATH" ]] && [[ "" != "`which java`" ]];
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): WARNING: Setting JDK from PATH (which java | sed -e 's#/bin/java\$##': '`which java | sed -e 's#/bin/java$##'`').\n"
	JAVA_ROOT=`which java | sed -e 's#/bin/java$##'`

else
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: No Passed in JDK and Couldn't find a valid JDK in JDK_HOME, JAVA_HOME or PATH to Execute!\n\nExiting...\n"
	exit -1
fi

echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): JAVA_ROOT: '$JAVA_ROOT'"

# Check if The '/usr/bin/time' Executable Exists:
if [[ ! -a /usr/bin/time ]] || ! hash time 2>/dev/null;
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: The '/usr/bin/time' Executable Doesn't Exist!\n\nExiting...\n"
	exit -1
fi

# Check if The 'curl' Executable Exists:
if ! hash curl 2>/dev/null;
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: The 'curl' Executable Doesn't Exist!\n\nExiting...\n"
	exit -1
fi

# Check if The 'javac' Executable Exists:
if ! hash javac 2>/dev/null;
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: The 'javac' Executable Doesn't Exist!\n\nExiting...\n"
	exit -1
fi

# Check if The 'java' Executable Exists:
if ! hash java 2>/dev/null;
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: The 'java' Executable Doesn't Exist!\n\nExiting...\n"
	exit -1
fi

# Check if The 'cpupower' Executable Exists:
if ! hash cpupower 2>/dev/null;
then
	echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: The 'cpupower' Executable Doesn't Exist!\n\nExiting...\n"
	exit -1
fi

case $(uname -m) in
    aarch64)
		case $(uname -n) in
			Khadas)
				# vim3 has 6 cpus, we need to disable 0 and 1 since they are A53 cores
				echo 0 | sudo tee /sys/devices/system/cpu/cpu0/online
				echo 0 | sudo tee /sys/devices/system/cpu/cpu1/online

				# vim3 is at 1.30
				sudo ./lock_frequency.sh "1.30"
				CPU_TYPE="A73"
				;;
			casa-pi4b-1)
				# Raspberry Pi 4 B is at 1.30
				sudo ./lock_frequency.sh "1.30"
				CPU_TYPE="A72"
				;;
			*)
				# rock64 is at 1.30
				sudo ./lock_frequency.sh "1.30"
				CPU_TYPE="A53"
				;;
		esac
        ;;
    x86_64)
		case $(uname -n) in
			beelink1)
				# atom board closest frequency is 1.28
				sudo ./lock_frequency.sh "1.28"
				CPU_TYPE="amd64"
				;;
			*)
				CPU_TYPE="amd64"
				;;
		esac
        ;;
	*)
		echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: Architecture '$(uname -m)' Not Supported!\n\nExiting...\n"
		exit -1
        ;;
esac

ITERATE="1"
BENCHMARK_DIR=(
	"Benchmarks/SPECjvm2008"
	"Benchmarks/DaCapo"
	"Benchmarks/ScimarkC"
	"Benchmarks/ScimarkJava"
	"Benchmarks/RenaissanceSuite"
)

JAVA_HOME="${JAVA_ROOT}"

# More OpenJ9 Command-Line Options:
# -verbose:sizes
# -Xjit:disableCompactLocals
# -Xint
# -Xjit:exclude={java/io/Object*.*}
# -Xss2M
# -Xjit:disableEscapeAnalysis
# -Xdump:java+system:events=throw+systhrow,filter=java/lang/StackOverflowError
JAVA_OPTS=" -Xms2G -Xmx2G "

VM="$(basename "${JAVA_ROOT}")"

echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): CPU_TYPE: '$CPU_TYPE'"
echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): BENCHMARK_DIR[@]: '${BENCHMARK_DIR[@]}'"
echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): JAVA_HOME: '$JAVA_HOME'"
echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): JAVA_OPTS: '$JAVA_OPTS'"
echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): VM: '$VM'\n"

# Is a built-from-source JVM:
if [[ "jdk" == "${VM}" ]];
then
	VM="${JAVA_ROOT}"
	echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): INFO: Setting 'VM' as built-from-source JVM (VM: 'jdk' -> '$VM')\n"
fi

for BENCHMARK in ${BENCHMARK_DIR[@]}
do
	pushd "${BENCHMARK}" || exit 1

	case "${VM}" in
		*openj9*)
			VM="openj9"
		;;

		*j9*)
			VM="openj9"
		;;

		*hotspot*)
			VM="hotspot"
		;;

		*)
			echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): ERROR: Unknown JVM VM: '${VM}' in JAVA_ROOT: '${JAVA_ROOT}'! Expecting an OpenJ9 or Hotspot JVM.\n\nExiting...\n"
			exit -1
		;;
	esac

	# echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): VM: '$VM'"
	# echo -e "${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): JAVA_OPTS: '$JAVA_OPTS'\n"

	for (( i=1; i <= ITERATE; i++ ))
	do
		make CPU_TYPE="${CPU_TYPE}" VM="${VM}" JAVA_HOME="${JAVA_HOME}" JAVA_OPTS="${JAVA_OPTS}"
	done

	popd || exit 1
done

echo -e "\n${0##*/}@${HOSTNAME}:$( date "+%Y.%m.%d.%H%M.%S" ): End (RC: '$?').\n\n"
