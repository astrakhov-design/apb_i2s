class apb_sequence extends uvm_sequence#(apb_seq_item);

  `uvm_object_utils(apb_sequence)

  //constructor
  function new(string name = "apb_sequence");
    super.new(name);
  endfunction

  `uvm_declare_p_sequencer(apb_sequencer)

  virtual task body();
    repeat(2) begin
      req = apb_seq_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
    end
  endtask

endclass

class apb_wr extends uvm_sequence#(apb_seq_item);

  rand bit [`uvm_apb_dsize-1:0] wr_seq_rw_data;
  rand bit [`uvm_apb_asize-1:0] wr_seq_addr;
  integer                       wr_delay;

  `uvm_object_utils(apb_wr)

  function new(string name = "apb_wr");
    super.new(name);
    wr_delay = 1;
  endfunction

  function init(bit [`uvm_apb_dsize-1:0] i_wr_seq_rw_data = 0,
                bit [`uvm_apb_asize-1:0] i_wr_seq_addr = 0);
    wr_seq_rw_data =  i_wr_seq_rw_data;
    wr_seq_addr    =  i_wr_seq_addr;
  endfunction

  virtual task body();
    `uvm_do_with(req,{rw_data ==  wr_seq_rw_data;
                      addr    ==  wr_seq_addr;
                      we      ==  1;
                      delay   ==  wr_delay;})
    get_response(req);
  `uvm_info(get_type_name(), $sformatf("Written Addr: 0x%h, Written Data: 0x%h", req.addr, req.rw_data), UVM_MEDIUM)
  endtask

endclass

class apb_rd extends uvm_sequence#(apb_seq_item);

  rand bit [`uvm_apb_asize-1:0] rd_seq_addr;
  rand bit [`uvm_apb_dsize-1:0] rd_seq_data;
  integer                       rd_delay;

  `uvm_object_utils(apb_rd)

  function new(string name = "apb_rd");
    super.new(name);
    rd_delay = 1;
  endfunction

  function init(bit [`uvm_apb_asize-1:0] i_rd_seq_addr = 0);
    rd_seq_addr   = i_rd_seq_addr;
  endfunction

  virtual task body();
    `uvm_do_with(req,{addr  ==  rd_seq_addr;
                      we    ==  0;
                      delay ==  rd_delay;})
    get_response(req);
  rd_seq_data = req.rw_data;
  `uvm_info(get_type_name(), $sformatf("EXIT ADDR: 0x%h, EXIT DATA: 0x%h", req.addr, req.rw_data), UVM_MEDIUM)

  endtask

endclass : apb_rd
