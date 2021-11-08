begin : default_test

  `wait_n_cycles(20)

  for(int i = 0; i < 4; i++) begin

  data_left_  = $urandom;
  data_right_ = $urandom;
  DATA_LEFT.push_front(data_left_);
  DATA_RIGHT.push_front(data_right_);

  `apb_write(`TXL_ADDR, data_left_)
  `apb_write(`TXR_ADDR, data_right_)
  
  end
  
  `apb_write(`CR_ADDR, 32'h01)
  
  
  for(int i = 0; i < 4; i++) begin
    data_left_  = DATA_LEFT.pop_back();
    data_right_ = DATA_RIGHT.pop_back();
    
  `i2s_rcv(data_left_, data_right_)
  end
  
  `uvm_info("DEFAULT_TEST", $sformatf("TEST PASSED"), UVM_NONE)
  
end : default_test