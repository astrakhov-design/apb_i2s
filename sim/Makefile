#Makefile for apb_i2s project
#author: astrakhov, JSC MERI
SEED = random
TN = debug_scratch
UVM_VERB ?= UVM_LOW

DEFINES = +define+SIM_STANDALONE

ifeq (${GUI}, 1)
  IRUN_GUI+=-gui
else
  NCINPUT+=+ncinput+"ncsim.cmds"
endif

ifeq (${CCOV}, 1)
  NCCOV = +nccoverage+all
endif

#no_uvm startup
all:
	@xrun -sv -64 -v93 -sem2009 -smartorder -timescale 1ns/1ps +tue \
	+access+rwc \
	-svseed ${SEED} \
	+incdir+"../rtl/apb_i2s" \
	+incdir+"../rtl/common" \
	+incdir+"../rtl/fifo_buffer" \
	${IRUN_GUI} \
	${NCINPUT} \
	../rtl/apb_i2s/apb_i2s.sv \
	../verification/tb.sv

#clean sim folder
clean:
	@rm -rf xcelium.d
	@rm 	*.key
	@rm	*.log
	@rm	*.history