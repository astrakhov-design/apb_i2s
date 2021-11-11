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
  NCCOV = +nccoverage+all -covtest ${TN}
endif

#no_uvm startup
all:
	@xrun -sv -64 -v93 -sem2009 -smartorder -timescale 1ns/1ps +tue \
	+access+rwc \
	-svseed ${SEED} \
	+incdir+"../verification" \
	${IRUN_GUI} \
	${NCINPUT} \
	-f ../common/rtl_list.f \
	-f ../common/tb_list.f

uvm:
	@xrun -sv -64 -v93 -sem2009 -smartorder -timescale 1ns/1ps -uvm +tue \
	+access+rwc \
	-svseed ${SEED} \
	+incdir+"../verification/uvm_tests" \
	+incdir+"../verification/uvm_tests/test_items" \
	+incdir+"../verification/apb_uvm_components" \
	+incdir+"../verification/i2s_uvm_components" \
	+UVM_TESTNAME=${TN} \
	+UVM_VERBOSITY=${UVM_VERB} \
	+nowarn+FUNTSK \
	+nowarn+MEMODR \
	+nowarn+REPCNT \
	+nowarn+LVLFNC \
	${NCCOV} \
	${NCINPUT} \
	${IRUN_GUI} \
	${DEFINES} \
	-f ../common/rtl_list.f \
	-f ../common/tb_uvm_list.f


#clean sim folder
clean:
	@rm -rf xcelium.d
	@rm 	*.key
	@rm	*.log
	@rm	*.history
	@rm	*.diag
	@rm -rf waves.shm
