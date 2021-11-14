//check FIFO work
//author: astrakhov, JSC MERI

class test_fifo extends test_standalone;
  `uvm_component_utils(test_fifo)

function new(string name = "test_fifo", uvm_component parent = null);
  super.new(name, parent);
endfunction

virtual task run_test_items();
  begin : test_fifo
  wait_n_cycles(20);

  `uvm_info(get_type_name(), $sformatf("Test test_fifo strated"), UVM_NONE)

  `uvm_info(get_type_name(), $sformatf("Check default SR_REG state"), UVM_NONE)
   SR_REG_test.RESERVED    = 'h0;
   SR_REG_test.i2s_tx_done = 1'b1;
   SR_REG_test.fifor_empty = 1'b1;
   SR_REG_test.fifol_empty = 1'b1;
   SR_REG_test.fifol_full  = 1'b0;
   SR_REG_test.fifor_full  = 1'b0;
   apb_read(`SR_ADDR, SR_REG_test);

//check TXL FIFO buffer state
  for(int i = 0; i < 5; i++) begin
    data_left_  = $urandom;
    DATA_LEFT.push_front(data_left_);
    apb_write(`TXL_ADDR, data_left_);
    case(DATA_LEFT.size())
      4,5: begin
        SR_REG_test.fifol_empty = 1'b0;
        SR_REG_test.fifol_full  = 1'b1;
      end
      default: begin
        SR_REG_test.i2s_tx_done = 1'b0;
        SR_REG_test.fifol_empty = 1'b0;
        SR_REG_test.fifol_full  = 1'b0;
      end
    endcase
    apb_read(`SR_ADDR, SR_REG_test);
  end    

//check TXR FIFO buffer state
  for(int i = 0; i < 5; i++) begin
    data_right_ = $urandom;
    DATA_RIGHT.push_front(data_right_);
    apb_write(`TXR_ADDR, data_right_);
    case(DATA_RIGHT.size())
      4,5: begin
        SR_REG_test.fifor_empty = 1'b0;
        SR_REG_test.fifor_full  = 1'b1;
        SR_REG_test.fifol_full  = 1'b1;
      end
      default: begin
        SR_REG_test.fifor_empty = 1'b0;
        SR_REG_test.fifor_full  = 1'b0;
        SR_REG_test.fifol_full  = 1'b1;
      end
    endcase
    apb_read(`SR_ADDR, SR_REG_test);
  end

  `uvm_info(get_type_name(), $sformatf("Test test_fifo finished"), UVM_NONE)

  end : test_fifo
endtask

endclass
