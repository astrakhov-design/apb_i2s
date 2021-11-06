//i2s scoreboard
//author: astrakhov, JSC MERI
//date: 06.11.2021

class i2s_scb extends uvm_scoreboard;

  `uvm_component_utils(i2s_scb)

  `uvm_analysis_imp_decl (_i2s)

  event complete_trans;
  i2s_seq_item  i2s_pkt;

  //port to recieve TLM packets from i2s_monitor
  uvm_analysis_imp_i2s#(i2s_seq_item, i2s_scb) item_collected_export_i2s;

  //create constructor
  function new (string name = "i2s_scb", uvm_component parent);
    super.new(name, parent);
  endfunction

  //declare package
  i2s_seq_item  pkt_qu[$];
  bit [31:0]    data_left_exp_qu[$];
  bit [31:0]    data_right_exp_qu[$];

  //build phase - create port and init local memory
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export_i2s = new("item_collected_export_i2s", this);
    i2s_pkt = new;
  endfunction

  //write task
  virtual function void write_i2s(i2s_seq_item pkt);
    pkt_qu.push_back(pkt);
  endfunction

  //run phase
  virtual task run_phase(uvm_phase phase);
    bit [31:0]  data_left_exp;
    bit [31:0]  data_right_exp;

    forever begin
      wait(pkt_qu.size() > 0);

      if(pkt_qu.size() > 0) begin
        i2s_pkt = pkt_qu.pop_front();

      if((data_left_exp_qu.size() > 0) &&
         (data_right_exp_qu.size() > 0)) begin
           data_left_exp  = data_left_exp_qu.pop_front();
           data_right_exp = data_right_exp_qu.pop_front();
      end

      if(i2s_pkt.data_left == data_left_exp) begin
        `uvm_info(get_type_name(), $sformatf("Data from left channel = %h OK", i2s_pkt.data_left), UVM_MEDIUM)
      end
      else begin
        `uvm_error(get_type_name(), $sformatf("Data from left channel %h does not match (expected %h)", i2s_pkt.data_left, data_left_exp));
        $stop;
      end

      if(i2s_pkt.data_right == data_right_exp) begin
        `uvm_info(get_type_name(), $sformatf("Data from left channel = %h OK", i2s_pkt.data_right), UVM_MEDIUM)
      end
      else begin
        `uvm_error(get_type_name(), $sformatf("Data from left channel %h does not match (expected %h)", i2s_pkt.data_right, data_right_exp));
        $stop;
      end

      ->complete_trans;
      end
    end
  endtask

endclass
