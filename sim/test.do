set UVM_TESTS_PATH +incdir+../verification/uvm_tests/
set UVM_TEST_ITEMS_PATH +incdir+../verification/uvm_tests/test_items
set APB_UVM_PATH +incdir+../verification/apb_uvm_components
set I2S_UVM_PATH +incdir+../verification/i2s_uvm_components

set TN i2s_unbreakable
set UVM_VERB UVM_LOW

transcript on

# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

vlog -coveropt 3 +cover +acc -f ../common/rtl_list.f
vlog $UVM_TESTS_PATH $UVM_TEST_ITEMS_PATH $APB_UVM_PATH $I2S_UVM_PATH -f ../common/tb_uvm_list.f
 

vsim +UVM_TESTNAME=${TN} +UVM_VERBOSITY=${UVM_VERB} -coverage -vopt work.tb_uvm -c -do "coverage save -onexit -directive -codeAll apb_i2s.ucdb; run -all" 


vcover report -html apb_i2s.ucdb
