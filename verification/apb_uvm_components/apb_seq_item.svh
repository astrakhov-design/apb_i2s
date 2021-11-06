class apb_seq_item extends uvm_sequence_item;
  `uvm_component_utils(apb_seq_item)

  rand bit [`uvm_apb_dsize-1:0] rw_data;
  rand bit [`uvm_apb_asize-1:0] addr;
  rand bit                    we; //0 -- read op, 1 -- write op
  rand integer                delay;

  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(rw_data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(we, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "apb_seq_item");
    super.new(name);
    delay = 0;
  endfunction

endclass : apb_seq_item
