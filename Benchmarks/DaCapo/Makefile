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

BENCHMARK_NAME = Dacapo
VM ?= null
CPU_TYPE ?= null

INSTALLER=dacapo-9.12-MR1-bach.jar
URL=https://versaweb.dl.sourceforge.net/project/dacapobench/9.12-bach-MR1/$(INSTALLER)
EXECUTABLE_JAR=$(INSTALLER)

BENCHMARK_THREAD ?= 4

JAVA_OPTS ?= -Xint

##################
# setup BM
RUNNER := $(JAVA_HOME)/bin/java $(JAVA_OPTS) -jar $(EXECUTABLE_JAR) \
	--thread-count $(BENCHMARK_THREAD)

ALL := \
	avrora \
	fop \
	h2 \
	jython \
	luindex \
	lusearch \
	lusearch-fix \
	pmd \
	sunflow \
	xalan

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
	@sleep 60
	@mkdir -p $(RUN_DIR)
	printf "" > $(RUN_DIR)/$@.txt
	@echo "-- BENCHMARK_NAME: $(BENCHMARK_NAME)" >> $(RUN_DIR)/$@.txt	
	@echo "-- VM: $(VM)" >> $(RUN_DIR)/$@.txt
	@echo "-- CPU_TYPE: $(CPU_TYPE)" >> $(RUN_DIR)/$@.txt
	@echo ""
	@echo "===== Executing $@ (log: $(RUN_DIR)/$@.txt) ====="
	/usr/bin/time $(RUNNER) $@ 2>&1 | tee -a $(RUN_DIR)/$@.txt

all: $(ALL)

