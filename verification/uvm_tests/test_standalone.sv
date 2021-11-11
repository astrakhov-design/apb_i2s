//standalone test for UVM testbench
//author: astrakhov, JSC MERI
//date: 06.11.2021

//`include "macros.svh"
`include "uvm_macros.svh"


class test_standalone extends uvm_test;

  `uvm_component_utils(test_standalone)

//declare testbench components
  i2s_env i2s_env_i;  //env : i2s_env
  i2s_rcv i2s_rcv_i;  //sequence: i2s_rcv
  apb_env apb_env_i;  //environment: APB
  apb_wr  apb_wr_i;   //sequence: APB write
  apb_rd  apb_rd_i;   //sequence: APB read

//declare virtual interfaces
  virtual i2s_uvc_interface i2s_vif;
  virtual apb_interface apb_if;

//define constructor
  function new (string name = "test_standalone", uvm_component parent = null);
    super.new(name, parent);
  endfunction

//build phase for the test_standalone class
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    i2s_env_i = i2s_env::type_id::create("i2s_env_i", this);
    i2s_rcv_i = i2s_rcv::type_id::create("i2s_rcv_i", this);
    apb_env_i = apb_env::type_id::create("apb_env_i", this);
    apb_wr_i  = apb_wr::type_id::create("apb_wr_i", this);
    apb_rd_i  = apb_rd::type_id::create("apb_rd_i", this);

    if(!uvm_config_db#(virtual apb_interface)::get(this,"","apb_if",apb_if))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".apb_if"});
    if(!uvm_config_db#(virtual i2s_uvc_interface)::get(this,"","i2s_vif",i2s_vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".i2s_vif"});

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
    
    super.run_phase(phase);
    phase.raise_objection(this);
        
    this.run_test_items();

    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this, 500);

  endtask

//user variables put HERE
  virtual task apb_write(
   input [31:0] addr,
   input [31:0] data_); 
    begin
      apb_wr_i.wr_seq_rw_data = data_;
      apb_env_i.apb_scb_i.payload_exp_qu.push_back(data_);
      apb_wr_i.wr_seq_addr = addr;
      apb_wr_i.start(apb_env_i.apb_agent_i.sequencer);
    end
  endtask
  
  virtual task apb_read(
    input [31:0] addr,
    input [31:0] data_);
    begin
     apb_rd_i.rd_seq_addr = addr;
     apb_env_i.apb_scb_i.payload_exp_qu.push_back(data_);
     apb_rd_i.start(apb_env_i.apb_agent_i.sequencer);
    end
  endtask

  virtual task wait_n_cycles(
    input integer ncycles);
    begin
      repeat(ncycles) @ (posedge apb_env_i.apb_agent_i.monitor.apb_if.clk);
    end
  endtask
  
  virtual task rcv_i2s(
    input [31:0]  data_left,
    input [31:0]  data_right
  );
    begin
      i2s_env_i.i2s_scb_i.data_left_exp_qu.push_back(data_left);
      i2s_env_i.i2s_scb_i.data_right_exp_qu.push_back(data_right);
      @(i2s_env_i.i2s_agent_i.monitor.recording_finished);
    end
  endtask

bit [31:0]  data_left_;
bit [31:0]  data_right_;

bit [31:0]  DATA_LEFT [$];
bit [31:0]  DATA_RIGHT [$];

struct packed {
  logic [26:0]  RESERVED;
  logic         i2s_tx_done;
  logic         fifor_empty;
  logic         fifor_full;
  logic         fifol_empty;
  logic         fifol_full; 
} SR_REG_test;

endclass
