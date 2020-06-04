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


JAVA_OPTS ?= -Xint

ITTERATION=30

SCIMARK := \
	scimark.fft \
	scimark.lu \
	scimark.sor \
	scimark.sparse \
	scimark.monte_carlo

##################
# setup BM

RUNNER := $(JAVA_HOME)/bin/java $(JAVA_OPTS)

TEMP_DIR := $(CURDIR)/run
RUN_DIR := $(shell mkdir -p $(TEMP_DIR)/$(_REPO_FIX); mktemp -d $(TEMP_DIR)/$(_REPO_FIX)/run_XXX)
PARSER := $(CURDIR)/../../parse_bm.py 
PARSER_CONF := $(CURDIR)/parse.conf

#################################
# begin
default: run

scimarkJava:
	git clone https://github.com/jeanlego/scimarkJava.git

build: scimarkJava
	cd scimarkJava && git reset --hard origin/master && git clean -dxf && git pull && make 

run: build $(RUN_DIR)
        mkdir -p $@
	@printf "\n===== Executing $@ (log: $(RUN_DIR)/$@.txt) =====\n"
	cd scimarkJava && /usr/bin/time $(RUNNER) $@ $(ITTERATION) 2>&1 | tee $(RUN_DIR)/$@.txt

