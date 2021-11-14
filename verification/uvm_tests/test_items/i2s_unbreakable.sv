//test i2s_unbreakable
//author: astrakhov, JSC MERI
//date: 13.11.2021

class i2s_unbreakable extends test_standalone;

  `uvm_component_utils(i2s_unbreakable)

function new(string name = "i2s_unbreakable", uvm_component parent = null);
  super.new(name, parent);
endfunction

virtual task run_test_items();
  begin
  wait_n_cycles(20);

`uvm_info(get_type_name(), $sformatf("Test i2s_unbreakable started"), UVM_NONE)


//load both buffers
  for(int i = 0; i < 4; i++) begin
    data_left_  = $urandom;
    data_right_ = $urandom;
    DATA_LEFT.push_front(data_left_);
    DATA_RIGHT.push_front(data_right_);
    apb_write(`TXL_ADDR, data_left_);
    apb_write(`TXR_ADDR, data_right_);
  end

    apb_read_data(`SR_ADDR, apb_data);

//set I2S_enable
  `uvm_info(get_type_name(), $sformatf("Set I2S_ENABLE"), UVM_NONE)
   apb_write(`CR_ADDR, 32'h01);

for(int i = 0; i < 25; i++) begin : repeat_counting

fork

  begin //check I2S data
    data_left_  = DATA_LEFT.pop_back();
    data_right_ = DATA_RIGHT.pop_back();
    rcv_i2s(data_left_, data_right_);
  end

  begin
  while(apb_data != 32'h00000000) begin
    apb_read_data(`SR_ADDR, apb_data);
  end
  if(apb_data == 32'h00000000) begin
    data_left_  = $urandom;
    data_right_ = $urandom;
    DATA_LEFT.push_front(data_left_);
    DATA_RIGHT.push_front(data_right_);
    apb_write(`TXL_ADDR, data_left_);
    apb_write(`TXR_ADDR, data_right_);
    apb_read_data(`SR_ADDR, apb_data);
  end
  end

join

end : repeat_counting

for(int i = 0; i < 4; i++) begin
  data_left_  = DATA_LEFT.pop_back();
  data_right_ = DATA_RIGHT.pop_back();
  rcv_i2s(data_left_, data_right_);
end

  `uvm_info(get_type_name(), $sformatf("Test i2s_unbreakable is done"), UVM_NONE)

  end
endtask

endclass
