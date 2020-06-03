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

EXECUTABLE_CLASS=scimarkJava/commandline.class

PERF_CMD := perf stat record -a -d -d -d

BENCHMARK_THREAD ?= 4
BENCHMARK_NAME := ScimarkJava

JAVA_OPTS ?= -Xint


##################
# setup BM

RUNNER := $(JAVA_HOME)/bin/java $(JAVA_OPTS) jnt.scimark2.commandline 30

TEMP_DIR := $(CURDIR)/run
RUN_DIR := $(shell mkdir -p $(TEMP_DIR)/$(_REPO_FIX); mktemp -d $(TEMP_DIR)/$(_REPO_FIX)/run_XXX)
PARSER := $(CURDIR)/../../parse_bm.py 
PARSER_CONF := $(CURDIR)/parse.conf

#################################
# begin
default: run

$(RUN_DIR):
	mkdir -p $@

scimarkJava:
	git clone https://github.com/jeanlego/scimarkJava.git

build: scimarkJava
	cd scimarkJava && git reset --hard origin/master && git clean -dxf && git pull && make 

run: build $(RUN_DIR)
	@printf "\n===== Executing $@ (log: $(RUN_DIR)/$@.txt) =====\n"
	cd scimarkJava && /usr/bin/time $(RUNNER) 2>&1 | tee $(RUN_DIR)/$@.txt

