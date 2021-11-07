//debug_scratch test
//author: astrakhov, JSC MERI
//date: 07.11.2021

class debug_scratch extends test_standalone;
  `uvm_component_utils(debug_scratch)

  bit [31:0]  data_;
  bit [31:0]  addr;

  virtual task run_test_items();
    begin

  `uvm_info("INITIAL", $sformatf("TEST CHECK"), UVM_NONE)
    data_ = 32'h0;
    addr  = 32'h0;
    
    apb_wr_i.wr_seq_rw_data = data_;
    apb_env_i.apb_scb_i.payload_exp_qu.push_back(data_);
    apb_wr_i.wr_seq_addr = addr;
    apb_wr_i.start(apb_env_i.apb_agent_i.sequencer);
    
  `uvm_info("INITIAL", $sformatf("DATA SENT VIA APB BUS"), UVM_NONE)
  
    end
  
  endtask
  
  function new(string name = "debug_scratch", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  

endclass
