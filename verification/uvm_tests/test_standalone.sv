//standalone test for UVM testbench
//author: astrakhov, JSC MERI
//date: 06.11.2021

`include "macros.svh"

class test_standalone extends uvm_tests;

  `uvm_component_utils(test_standalone)

//declare testbench components
  i2s_env i2s_env_i;  //env : i2s_env
  apb_env apb_env_i;  //environment: APB
  apb_wr  apb_wr_i;   //sequence: APB write
  apb_rd  apb_rd_i;   //sequence: APB read

//declare virtual interfaces
  virtual i2s_interface i2s_vif;

//define constructor
  function new (string name, uvm_component parent = null);
    super.new(new, parent);
  endfunction

//build phase for the test_standalone class
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    i2s_env_i = i2s_env::type_id::create("i2s_env_i", this);
    apb_env_i = apb_env::type_id::create("apb_env_i", this);
    apb_wr_i  = apb_wr::type_id::create("apb_wr_i", this);
    apb_rd_i  = apb_rd::type_id::create("apb_rd_i", this);

    if(!uvm_config_db#(i2s_vif)::get(this, "", "i2s_vif", i2s_interface)) begin
      `uvm_error(get_type_name(), "i2s interface not found!")
    end

  endfunction

//print topology of uvm_factory
  virtual function void end_of_elaboration_phase (uvm_phase phase);
    uvm_top.print_topology();
  endfunction

//create a virtual task to call instead of parent
  virtual task run_test_items();

  endtask

//run phase function
  virtual task run_phase (uvm_phase phase);

    phase.raise_objection(this);
    this.run_test_items();

    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this, 500);

  endtask

//user variables put HERE

endclass

`create_test(debug_scratch)
