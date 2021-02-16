# Authors: Aaron Graham (aaron.graham@unb.ca, aarongraham9@gmail.com) and
#          Jean-Philippe Legault (jlegault@unb.ca, jeanphilippe.legault@gmail.com)
#           for the Centre for Advanced Studies - Atlantic (CAS-Atlantic) at the
#            Univerity of New Brunswick in Fredericton, New Brunswick, Canada

ifndef JAVA_HOME
$(error JAVA_HOME is not set)
endif

export TIME=\n\
        Elapsed Time:      %e Seconds\n\
        CPU:               %P\n\
        Max Memory:        %M KiB\n\
        Average Memory:    %K KiB\n\
        Minor PF:          %R\n\
        Major PF:          %F\n\
        Context Switch:    %c+%w\n\
        Program Exit Code: %x\n

BENCHMARK_NAME = RenaissanceSuite
VM ?= null
CPU_TYPE ?= null

INSTALLER=renaissance-gpl-0.11.0.jar
URL=https://github.com/renaissance-benchmarks/renaissance/releases/download/v0.11.0/$(INSTALLER)
EXECUTABLE_JAR=$(INSTALLER)

BENCHMARK_THREAD ?= 4

JAVA_OPTS ?= -Xint

##################
# setup BM
RUNNER := $(JAVA_HOME)/bin/java $(JAVA_OPTS) -jar $(EXECUTABLE_JAR)

# actors:
#	akka-uct \ # Runs the Unbalanced Cobwebbed Tree actor workload in Akka. (default repetitions: 24)
#	reactors \ # Runs benchmarks inspired by the Savina microbenchmark workloads in a sequence on Reactors.IO. (default repetitions: 10)
# apache-spark:
#	als \ #	# Runs the ALS algorithm from the Spark MLlib. (default repetitions: 30)
#	chi-square \ # Runs the chi-square test from Spark MLlib. (default repetitions: 60)
#	dec-tree \ # Runs the Random Forest algorithm from Spark MLlib. (default repetitions: 40)
#	gauss-mix \ # Computes a Gaussian mixture model using expectation-maximization. (default repetitions: 40)
#	log-regression \ # Runs the logistic regression workload from the Spark MLlib. (default repetitions: 20)
#	movie-lens \ # Recommends movies using the ALS algorithm. (default repetitions: 20)
#	naive-bayes \ # Runs the multinomial naive Bayes algorithm from the Spark MLlib. (default repetitions: 30)
#	page-rank \ # Runs a number of PageRank iterations, using RDDs. (default repetitions: 20)
# database:
#	db-shootout \ # Executes a shootout test using several in-memory databases. (default repetitions: 16)
# jdk-concurrent:
#	fj-kmeans \ # Runs the k-means algorithm using the fork/join framework. (default repetitions: 30)
#	future-genetic \ # Runs a genetic algorithm using the Jenetics library and futures. (default repetitions: 50)
# jdk-streams:
#	mnemonics \ # Solves the phone mnemonics problem using JDK streams. (default repetitions: 16)
#	par-mnemonics \ # Solves the phone mnemonics problem using parallel JDK streams. (default repetitions: 16)
#	scrabble \ # Solves the Scrabble puzzle using JDK Streams. (default repetitions: 50)
# neo4j:
#	neo4j-analytics \ # Executes Neo4J graph queries against a movie database. (default repetitions: 20)
# rx:
#	rx-scrabble \ # Solves the Scrabble puzzle using the Rx streams. (default repetitions: 80)
# scala-dotty:
#	dotty \ # Runs the Dotty compiler on a set of source code files. (default repetitions: 50)
# scala-sat:
#	scala-doku \ # Solves Sudoku Puzzles using Scala collections. (default repetitions: 20)
# scala-stdlib:
#	scala-kmeans \ # Runs the K-Means algorithm using Scala collections. (default repetitions: 50)
# scala-stm:
#	philosophers \ # Solves a variant of the dining philosophers problem using ScalaSTM. (default repetitions: 30)
#	scala-stm-bench7 \ # Runs the stmbench7 benchmark using ScalaSTM. (default repetitions: 60)
# twitter-finagle:
#	finagle-chirper \ # Simulates a microblogging service using Twitter Finagle. (default repetitions: 90)
#	finagle-http # Sends many small Finagle HTTP requests to a Finagle HTTP server and awaits response. (default repetitions: 12)
ALL := \
	akka-uct \
	reactors \
	als \
	chi-square \
	dec-tree \
	gauss-mix \
	log-regression \
	movie-lens \
	naive-bayes \
	page-rank \
	db-shootout \
	fj-kmeans \
	future-genetic \
	mnemonics \
	par-mnemonics \
	scrabble \
	neo4j-analytics \
	rx-scrabble \
	dotty \
	scala-doku \
	scala-kmeans \
	philosophers \
	scala-stm-bench7 \
	finagle-chirper \
	finagle-http

TEMP_DIR := $(CURDIR)/run
RUN_DIR := $(shell mkdir -p $(TEMP_DIR)/$(_REPO_FIX); mktemp -d $(TEMP_DIR)/$(_REPO_FIX)/run_XXX)
PARSER := $(CURDIR)/../../parse_bm.py
PARSER_CONF := $(CURDIR)/parse.conf

#################################
# begin
default: all

$(EXECUTABLE_JAR):
	[ -f "$(EXECUTABLE_JAR)" ] || curl -L $(URL) -o $(EXECUTABLE_JAR)

$(ALL): $(EXECUTABLE_JAR)
	@mkdir -p $(RUN_DIR)
	printf "" > $(RUN_DIR)/$@.txt
	@echo "-- BENCHMARK_NAME: $(BENCHMARK_NAME)" >> $(RUN_DIR)/$@.txt	
	@echo "-- VM: $(VM)" >> $(RUN_DIR)/$@.txt
	@echo "-- CPU_TYPE: $(CPU_TYPE)" >> $(RUN_DIR)/$@.txt
	@echo ""
	@echo "===== Executing $@ (log: $(RUN_DIR)/$@.txt) ====="
	/usr/bin/time $(RUNNER) $@ 2>&1 | tee -a $(RUN_DIR)/$@.txt
	@sleep 20

all: $(ALL)

