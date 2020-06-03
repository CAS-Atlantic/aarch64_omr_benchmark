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

PERF_CMD := /usr/bin/time

BENCHMARK_THREAD ?= 4
BENCHMARK_NAME := ScimarkC


##################
# setup BM

TEMP_DIR := $(CURDIR)/run
RUN_DIR := $(shell mkdir -p $(TEMP_DIR)/$(_REPO_FIX); mktemp -d $(TEMP_DIR)/$(_REPO_FIX)/run_XXX)
PARSER := $(CURDIR)/../../parse_bm.py 
PARSER_CONF := $(CURDIR)/parse.conf

#################################
# begin

default: run

$(RUN_DIR):
	mkdir -p $@

scimarkC:
	git clone https://github.com/jeanlego/scimarkC.git

build: scimarkC
	cd scimarkC && git reset --hard origin/master && git clean -dxf && git pull && make

run: build $(RUN_DIR)
	@printf "\n===== Executing $@ (log: $(RUN_DIR)/$@.txt) =====\n"
	/usr/bin/time ./scimarkC/scimark 30 2>&1 | tee $(RUN_DIR)/$@.txt

