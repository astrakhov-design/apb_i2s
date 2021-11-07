//i2s monitor class
//author: astrakhov, JSC MERI
//date: 31.10.2021

class i2s_monitor extends uvm_monitor;
  `uvm_component_utils(i2s_monitor)

  virtual i2s_uvc_interface i2s_vif;

  event left_channel_select;
  event left_channel_msb;
  event left_channel_lsb;
  event right_channel_select;
  event right_channel_msb;
  event right_channel_lsb;

  bit [31:0] data_left_;
  bit [31:0] data_right_;

  int transaction_counter;
  int transaction_counter_old;

  uvm_analysis_port # (i2s_seq_item) i2s_mon_analysis_port;

  //plaseholder to capture transaction info
  i2s_seq_item trans_collected;

  //Constructor for this class
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    transaction_counter = 0;
    //create an instance of the analysis port
    i2s_mon_analysis_port = new ("i2s_mon_analysis_port", this);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

  //get virtual interface handle from the configuration_db
  if(!uvm_config_db #(virtual i2s_uvc_interface) :: get(this, "", "i2s_vif", i2s_vif)) begin
    `uvm_error(get_type_name(), "DUT interface not found")
  end
endfunction

virtual task run_phase (uvm_phase phase);
  transaction_counter = 0;
  transaction_counter_old = 0;
  forever begin
    //change WS to left channel package
    fork
    @(negedge i2s_vif.WS) begin //first process
      ->left_channel_select;
      repeat(1) @ (negedge i2s_vif.TCLK);
      transaction_counter++;
      //start to write in left channel
      while(!i2s_vif.WS) begin
        data_left_ = {data_left_[30:0], i2s_vif.TD};
        repeat(1) @ (negedge i2s_vif.TCLK);
      end
    @(posedge i2s_vif.WS);
      ->right_channel_select;
      //send LSB of left channel lo data_left
      data_left_ = {data_left_[30:0], i2s_vif.TD};
      while(i2s_vif.WS) begin
        repeat(1) @ (negedge i2s_vif.TCLK);
        data_right_ = {data_right_[30:0], i2s_vif.TD};
      end
      ->right_channel_lsb;
    end
    @(right_channel_lsb) begin //second sub-process
      @(negedge i2s_vif.WS);
      data_right_ = {data_right_[30:0], i2s_vif.TD};
      repeat(1) @ (negedge i2s_vif.TCLK);
      trans_collected.data_left = data_left_;
      trans_collected.data_right = data_right_;
      i2s_mon_analysis_port.write(trans_collected);
      trans_collected.print();
    end
  join_none
  end
endtask

endclass
