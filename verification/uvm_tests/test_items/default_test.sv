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

      for(int i = 0; i < 1; i++) begin
        data_left_  = $urandom;
        data_right_ = $urandom;
        DATA_LEFT.push_front(data_left_);
        DATA_RIGHT.push_front(data_right_);
        apb_write(`TXL_ADDR, data_left_);
        apb_write(`TXR_ADDR, data_right_);
      end
    
      apb_write(`CR_ADDR, 32'h01);
  
      for(int i = 0; i < 1; i++) begin
        data_left_  = DATA_LEFT.pop_back();
        data_right_ = DATA_RIGHT.pop_back();
        rcv_i2s(data_left_, data_right_);
      end
  
      `uvm_info("DEFAULT_TEST", $sformatf("TEST PASSED"), UVM_NONE)
  
    end : default_test
  endtask
  
endclass
