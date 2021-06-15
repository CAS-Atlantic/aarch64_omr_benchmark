#!/bin/bash
# Authors: Aaron Graham (aaron.graham@unb.ca, aarongraham9@gmail.com) and
#          Jean-Philippe Legault (jlegault@unb.ca, jeanphilippe.legault@gmail.com)
#           for the Centre for Advanced Studies - Atlantic (CAS-Atlantic) at the
#            Univerity of New Brunswick in Fredericton, New Brunswick, Canada

PARSER="${PWD}/parse_result.py"
BENCHMARK_DIR="${PWD}/Benchmarks"
RESULT_DIR="${PWD}/results"
mkdir -p ${RESULT_DIR}

function _parse() {
	${PARSER} join --csv ${BENCHMARK_DIR}/parse_basic.toml **/*.txt
}

function _condense_result() {
	TEMP_DIR=${BENCHMARK_DIR}/$1/run

    if [ ! -d ${BENCHMARK_DIR}/$1/run ];
    then
        echo "no ${BENCHMARK_DIR}/$1/run to condense, Skipping"
	else

		for dir in $(ls ${BENCHMARK_DIR}/$1/run)
		do
			directories=${BENCHMARK_DIR}/$1/run/${dir}

			if [ -d ${directories} ] && [ "_0" != "_$(ls ${directories} | wc -w)" ]
			then
				mkdir -p ${RESULT_DIR}/$1/${dir}
				mv ${directories}/*.txt ${RESULT_DIR}/$1/${dir}/ &> /dev/null || /bin/true
			fi
		done

		rm -Rf ${BENCHMARK_DIR}/$1/run
	fi
}

for BENCHMARK in $(ls ${BENCHMARK_DIR})
do
    if [ -d ${BENCHMARK_DIR}/${BENCHMARK} ] 
    then
        _condense_result ${BENCHMARK}
		_parse  ${BENCHMARK}
    fi
done