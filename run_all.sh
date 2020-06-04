#!/bin/bash

JAVA_ROOT=/opt/jdk

CPU="n/a"
case $(uname -m) in
    aarch64)
		case $(uname -n) in
			Khadas)
				# vim3 is at 1.40
				sudo ./lock_frequency.sh "1.40"
				CPU="A73"
				;;
			*)
				# rock64 is at 1.30
				sudo ./lock_frequency.sh "1.30"
				CPU="A53"
				;;
		esac
        ;;
    *)
		# atom board closest frequency is 1.28
		sudo ./lock_frequency.sh "1.28"
		CPU="amd64"
        ;;
esac

ITTERATE="1"
BENCHMARK_DIR=(
#	"Benchmarks/SPECjvm2008"
#	"Benchmarks/DaCapo"
        "Benchmarks/ScimarkC"
        "Benchmarks/ScimarkJava"
)

for BENCHMARK in ${BENCHMARK_DIR[@]}
do
	pushd "${BENCHMARK}" || exit 1
	for jdk_v in "${JAVA_ROOT}"*
	do
		for jvm in "${jdk_v}"/*
		do
			JAVA_HOME="${jvm}"
			JAVA_OPTS=" -Xint -Xms2G -Xmx2G "
			case $(basename "${jvm}") in
				openj9)
					JAVA_OPTS="${JAVA_OPTS} -Xgcpolicy:optthruput -Xgcthreads2 -Xenableexcessivegc -Xgc:excessiveGCratio=95"
				;;

				hotspot)
					JAVA_OPTS="${JAVA_OPTS} -XX:+UseParallelGC -XX:ParallelGCThreads=2 -XX:GCTimeRatio=19"
				;;
			esac

			for (( i=1; i <= ITTERATE; i++ ))
			do
				make CPU="${CPU}" VM="$(basename "${jvm}")" JAVA_HOME="${JAVA_HOME}" JAVA_OPTS="${JAVA_OPTS}"
			done
		done
	done
	popd || exit 1
done
