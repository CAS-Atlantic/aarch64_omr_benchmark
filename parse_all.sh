#!/bin/bash

PARSER="${PWD}/parse_bm.py"
BENCHMARK_DIR="${PWD}/Benchmarks"
RESULT_DIR="${PWD}/results"
mkdir -p ${RESULT_DIR}

function _parse() {

    if [ ! -d ${RESULT_DIR}/$1 ];
    then
        echo "${RESULT_DIR}/$1 does not exist, Skipping"
    else
		if [ ! -f ${BENCHMARK_DIR}/$1/parse.conf ]
		then
			echo "no parse.conf directive for benchmark, Skipping"
		else
			print_header=true
			for dir in $(ls ${RESULT_DIR}/$1)
			do
				directories=${RESULT_DIR}/$1/${dir}

				if [ -d ${directories} ] && [ "_0" != "_$(ls ${directories} | wc -w)" ]
				then
					if [ "${print_header}" == "true" ]
					then
						${PARSER} \
							${BENCHMARK_DIR}/$1/parse.conf \
							${directories}/*.txt \
								&> ${RESULT_DIR}/$1.csv

						print_header=false
					else
						${PARSER} \
							${BENCHMARK_DIR}/$1/parse.conf \
							${directories}/*.txt \
								&>> ${RESULT_DIR}/$1.csv
					fi
				fi
			done
		fi
	fi
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