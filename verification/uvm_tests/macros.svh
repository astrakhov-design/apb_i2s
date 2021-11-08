//-------------------------------------

//         test creation

//-------------------------------------

  `define create_test(testname) \
   class testname extends test_standalone; \
    `uvm_component_utils(testname) \
    task run_test_items(); \
      `include `"testname.sv`" \
    endtask \
    function new(string name = `"testname`",uvm_component parent=null); \
     super.new(name,parent); \
    endfunction : new \
    endclass : testname
  
  `define call_test(testname) \
   $display(`"testname`"); \
   `include `"testname.sv`"

//i2s uvm macros
`define i2s_rcv(data_left, data_right) \
  begin \
    i2s_env_i.i2s_scb_i.data_left_exp_qu.push_back(data_left); \
    i2s_env_i.i2s_scb_i.data_right_exp_qu.push_back(data_right); \
    @(i2s_env_i.i2s_scb_i.complete_trans); \
  end


//wait i2s_vif.TCLK cycles
  `define wait_n_cycles_tclk(ncycles) \
    begin \
      repeat(ncycles) @ (negedge i2s_vif.TCLK); \
    end


  `define apb_write(addr, data_) \
    begin \
     apb_wr_i.wr_seq_rw_data = data_; \
     apb_env_i.apb_scb_i.payload_exp_qu.push_back(data_); \
     apb_wr_i.wr_seq_addr = addr; \
     apb_wr_i.start(apb_env_i.apb_agent_i.sequencer); \
    end

  `define apb_read(addr, data_) \
    begin \
     apb_rd_i.rd_seq_addr = addr; \
     apb_env_i.apb_scb_i.payload_exp_qu.push_back(data_); \
     apb_rd_i.start(apb_env_i.apb_agent_i.sequencer); \
    end
    
  `define wait_n_cycles(ncycles) \
   begin \
    repeat(ncycles) @(posedge apb_env_i.apb_agent_i.monitor.apb_if.clk); \
   end
