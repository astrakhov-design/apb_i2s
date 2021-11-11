//default_test
//check UVM libraries work
//author: astrakhov, JSC MERI

class default_test extends test_standalone;
  `uvm_component_utils(default_test)
  
  function new(string name = "default_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual task run_test_items();
    begin : default_test
      wait_n_cycles(20);
      
  `uvm_info(get_type_name(), $sformatf("Test Default Test started"), UVM_NONE)
      
  //check SR register default state 
  `uvm_info(get_type_name(), $sformatf("Check default SG_REG state"), UVM_NONE)
    SR_REG_test.RESERVED    = 'h0;
    SR_REG_test.i2s_tx_done = 1'b1;
    SR_REG_test.fifor_empty = 1'b1;
    SR_REG_test.fifol_empty = 1'b1;
    SR_REG_test.fifol_full  = 1'b0;
    SR_REG_test.fifor_full  = 1'b0;
    apb_read(`SR_ADDR, SR_REG_test);

  //fill TXR and TXL buffers
      for(int i = 0; i < 4; i++) begin
        data_left_  = $urandom;
        data_right_ = $urandom;
        DATA_LEFT.push_front(data_left_);
        DATA_RIGHT.push_front(data_right_);
        apb_write(`TXL_ADDR, data_left_);
        apb_write(`TXR_ADDR, data_right_);
      end
    
  //check SR status flags
  `uvm_info(get_type_name(), $sformatf("Check SR_REG state"), UVM_NONE)
    SR_REG_test.i2s_tx_done = 1'b0;
    SR_REG_test.fifor_empty = 1'b0;
    SR_REG_test.fifol_empty = 1'b0;
    SR_REG_test.fifol_full  = 1'b1;
    SR_REG_test.fifor_full  = 1'b1;
    apb_read(`SR_ADDR, SR_REG_test);
    
  `uvm_info(get_type_name(), $sformatf("Set I2S_ENABLE"), UVM_NONE)
    apb_write(`CR_ADDR, 32'h01);
  
      for(int i = 0; i < 4; i++) begin
        data_left_  = DATA_LEFT.pop_back();
        data_right_ = DATA_RIGHT.pop_back();
        rcv_i2s(data_left_, data_right_);
      end
    
  `uvm_info(get_type_name(), $sformatf("Check CR_REG state"), UVM_NONE)
    apb_read(`CR_ADDR, 32'h0);
      
  `uvm_info(get_type_name(), $sformatf("Check SR_REG state"), UVM_NONE)
    SR_REG_test.i2s_tx_done = 1'b1;
    SR_REG_test.fifor_empty = 1'b1;
    SR_REG_test.fifol_empty = 1'b1;
    SR_REG_test.fifol_full  = 1'b0;
    SR_REG_test.fifor_full  = 1'b0;
    apb_read(`SR_ADDR, SR_REG_test);
  
   `uvm_info(get_type_name(), $sformatf("TEST PASSED"), UVM_NONE)
  
    end : default_test
  endtask
  
endclass
