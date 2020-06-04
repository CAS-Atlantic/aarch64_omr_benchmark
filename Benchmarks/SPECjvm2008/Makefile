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

INSTALLER=SPECjvm2008_1_01_setup.jar
URL=http://spec.cs.miami.edu/downloads/osg/java/$(INSTALLER)
EXECUTABLE_JAR=SPECjvm2008.jar

BENCHMARK_NAME = SPECjvm2008
VM ?= null
CPU_TYPE ?= null

BENCHMARK_THREAD ?= 4

JAVA_OPTS ?= -Xint
JAR := -jar $(EXECUTABLE_JAR)


##################
# setup BM
RUNNER := $(JAVA_HOME)/bin/java $(JAVA_OPTS) $(JAR) \
			--lagom \
			-Dspecjvm.print.progress=true \
			-Dspecjvm.benchmark.warmup.time=0 \
			-Dspecjvm.miniter=1 \
			-Dspecjvm.maxniter=1 \
			-Dspecjvm.benchmark.threads=$(BENCHMARK_THREAD) \
			-Dspecjvm.run.initial.check=false \
			-Dspecjvm.run.checksum.validation=false \
			-Dspecjvm.continue.on.error=true \
			-Dspecjvm.print.progress=true \
			--parseJvmArgs

CRYPTO := \
	crypto.aes \
	crypto.rsa \
	crypto.signverify

SCIMARK := \
	scimark.fft.large \
	scimark.lu.large \
	scimark.sor.large \
	scimark.sparse.large \
	scimark.fft.small \
	scimark.lu.small \
	scimark.sor.small \
	scimark.sparse.small \
	scimark.monte_carlo

STARTUP := \
	startup.helloworld \
	startup.compress \
	startup.crypto.aes \
	startup.crypto.rsa \
	startup.crypto.signverify \
	startup.mpegaudio \
	startup.scimark.fft \
	startup.scimark.lu \
	startup.scimark.monte_carlo \
	startup.scimark.sor \
	startup.scimark.sparse \
	startup.serial \
	startup.sunflow \
	startup.xml.transform \
	startup.xml.validation

XML := \
	xml.transform \
	xml.validation

OTHER := \
	compress \
	serial \
	derby \
	sunflow \
	mpegaudio

ALL := \
	$(CRYPTO) \
	$(SCIMARK) \
	$(STARTUP) \
	$(XML) \
	$(OTHER)

TEMP_DIR := $(CURDIR)/run
RUN_DIR := $(shell mkdir -p $(TEMP_DIR)/$(_REPO_FIX); mktemp -d $(TEMP_DIR)/$(_REPO_FIX)/run_XXX)
PARSER := $(CURDIR)/../../parse_bm.py 
PARSER_CONF := $(CURDIR)/parse.conf

#################################
# begin
default: all

$(INSTALLER):
	[ -f "$(INSTALLER)" ] || curl -L $(URL) -o $(INSTALLER)

$(EXECUTABLE_JAR): $(INSTALLER)
	[ -f "$(EXECUTABLE_JAR)" ] || $(JAVA_HOME)/bin/java $(JAVA_OPTS) -jar $(INSTALLER) \
			-DUSER_INSTALL_DIR=./ \
			-i silent

$(ALL): $(EXECUTABLE_JAR)
	@mkdir -p $(RUN_DIR)
	@printf "-- BENCHMARK_NAME: $(BENCHMARK_NAME)\n" >> $(RUN_DIR)/$@.txt	
	@printf "-- VM: $(VM)\n" >> $(RUN_DIR)/$@.txt
	@printf "-- CPU_TYPE: $(CPU_TYPE)\n" >> $(RUN_DIR)/$@.txt
	@printf "\n===== Executing $@ (log: $(RUN_DIR)/$@.txt) =====\n"
	/usr/bin/time $(RUNNER) $@ 2>&1 | tee $(RUN_DIR)/$@.txt

crypto: $(CRYPTO)

scimark: $(SCIMARK)

startup: $(STARTUP)

xml: $(XML)

other: $(OTHER)

all: $(ALL)
