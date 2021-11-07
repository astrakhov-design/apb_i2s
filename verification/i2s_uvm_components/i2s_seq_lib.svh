//i2s sequence class
//author: astrakhov, JSC MERI
//date: 31.10.2021

class i2s_sequence extends uvm_sequence #(i2s_seq_item);
  `uvm_object_utils(i2s_sequence)

  //constructor of the class
  function new(string name = "i2s_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(2) begin
      req = i2s_seq_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
      get_responce(req);
    end
  endtask

endclass

class i2s_rcv extends uvm_sequence#(i2s_seq_item);
  `uvm_object_utils(i2s_rcv)

  bit [31:0] data_left_;
  bit [31:0] data_right_;

  function new(string name = "i2s_rcv");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req, {req.data_left == data_left_;
                       req.data_right == data_right_;})
  endtask

endclass
