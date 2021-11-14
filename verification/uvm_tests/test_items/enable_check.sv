//enable_check test
//author: astrakhov, JSC MERI
//date: 13.11.2021

class enable_check extends test_standalone;

  `uvm_component_utils(enable_check)

function new(string name = "enable_check", uvm_component parent = null);
  super.new(name, parent);
endfunction

virtual task run_test_items();
begin
wait_n_cycles(20);

`uvm_info(get_type_name(), $sformatf("Test enable_check started"), UVM_NONE)

//check SR_REG
`uvm_info(get_type_name(), $sformatf("Check SR_REG default state"), UVM_NONE)
apb_read(`SR_ADDR, 32'h0000001a);

//check CR_REG
`uvm_info(get_type_name(), $sformatf("Check CR_REG default state"), UVM_NONE)
apb_read(`CR_ADDR, 32'h00000000);

//Scenario 1: Set I2S_ENABLE with empty FIFO buffers
`uvm_info(get_type_name(), $sformatf("Scenario I: Set I2S_ENABLE with empty FIFO buffers"), UVM_NONE)
apb_write(`CR_ADDR, 32'h00000001);

wait_n_cycles(5);
apb_read(`SR_ADDR, 32'h0000001a);
apb_read(`CR_ADDR, 32'h00000000);

//Scenario 2: Set I2S_ENABLE with empty FIFO_left buffer
`uvm_info(get_type_name(), $sformatf("Scenario II: Set I2S_ENABLE with empty left FIFO buffer"), UVM_NONE)
data_right_ = $urandom;
apb_write(`TXR_ADDR, data_right_);
apb_write(`CR_ADDR, 32'h00000001);

wait_n_cycles(5);
apb_read(`SR_ADDR, 32'h00000012);
apb_read(`CR_ADDR, 32'h00000000);

//enable normal I2S transaction to clear buffer data
data_left_ = $urandom;
apb_write(`TXL_ADDR, data_left_);
apb_write(`CR_ADDR, 32'h00000001);

wait_n_cycles(5);

apb_read(`SR_ADDR, 32'h00000000);
apb_read(`CR_ADDR, 32'h00000001);
rcv_i2s(data_left_, data_right_);

wait_n_cycles(5);
apb_read(`SR_ADDR, 32'h0000001a);
apb_read(`CR_ADDR, 32'h00000000);

//Scenario 3: Set I2S_ENABLE with empty FIFO_right buffer
`uvm_info(get_type_name(), $sformatf("Scenario III: Set I2S_ENABLE with empty right FIFO buffer"), UVM_NONE)
data_left_ = $urandom;
apb_write(`TXL_ADDR, data_left_);
apb_write(`CR_ADDR, 32'h00000001);

wait_n_cycles(5);
apb_read(`SR_ADDR, 32'h00000018);
apb_read(`CR_ADDR, 32'h00000000);

//enable normal I2S transaction to clear buffer data
data_right_ = $urandom;
apb_write(`TXR_ADDR, data_right_);
apb_write(`CR_ADDR, 32'h00000001);

wait_n_cycles(5);

apb_read(`SR_ADDR, 32'h00000000);
apb_read(`CR_ADDR, 32'h00000001);
rcv_i2s(data_left_, data_right_);

wait_n_cycles(5);
apb_read(`SR_ADDR, 32'h0000001a);
apb_read(`CR_ADDR, 32'h00000000);

`uvm_info(get_type_name(), $sformatf("Test enable_check finished"), UVM_NONE)
end
endtask

endclass
