//i2s interface sequence item
//author: astrakhov, JSC MERI
//date: 31.10.2021

class i2s_seq_item extends uvm_sequence_item;

  //Data of the left channel
  rand bit [31:0] data_left;

  //Data of the right channel
  rand bit [31:0] data_right;

  //utility and field macros
  `uvm_object_utils_begin(i2s_seq_item)
    `uvm_field_int(data_left, UVM_ALL_ON)
    `uvm_field_int(data_right, UVM_ALL_ON)
  `uvm_object_utils_end

  //constructor of class
  function new(string name = "i2s_seq_item");
    super.new(name);
  endfunction

endclass
