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

##################
# setup BM

BENCHMARK_NAME = ScimarkC
VM ?= null
CPU_TYPE ?= null

ITTERATION=30

SCIMARK := \
	fft \
	lu \
	sor \
	sparse \
	monte_carlo

TEMP_DIR := $(CURDIR)/run
RUN_DIR := $(shell mkdir -p $(TEMP_DIR)/$(_REPO_FIX); mktemp -d $(TEMP_DIR)/$(_REPO_FIX)/run_XXX)
PARSER := $(CURDIR)/../../parse_bm.py 
PARSER_CONF := $(CURDIR)/parse.conf

#################################
# begin

default: run

build:
	rm -Rf scimarkC || /bin/true
	git clone https://github.com/jeanlego/scimarkC.git
	cd scimarkC && make

$(SCIMARK):
	@mkdir -p $(RUN_DIR)
	printf "" > $(RUN_DIR)/$@.txt
	@echo "-- BENCHMARK_NAME: $(BENCHMARK_NAME)" >> $(RUN_DIR)/$@.txt	
	@echo "-- VM: $(VM)" >> $(RUN_DIR)/$@.txt
	@echo "-- CPU_TYPE: $(CPU_TYPE)" >> $(RUN_DIR)/$@.txt
	@echo ""
	@echo "===== Executing $@ (log: $(RUN_DIR)/$@.txt) ====="
	cd scimarkC && /usr/bin/time ./bin/$@ $(ITTERATION) 2>&1 | tee -a $(RUN_DIR)/$@.txt

run: | build $(SCIMARK)
	

