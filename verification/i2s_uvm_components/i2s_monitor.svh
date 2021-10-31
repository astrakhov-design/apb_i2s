//i2s monitor class
//author: astrakhov, JSC MERI
//date: 31.10.2021

class i2s_monitor extends uvm_monitor # (i2s_seq_item);
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

  uvm_analysis_port # (i2s_seq_item) mon_analysis_port;

  //Constructor for this class
  function new (string name, uvm_componenet_parent = null);
    super.new(name, parent);
  endfunction

  virtual function build_phase (uvm_phase phase);
    super.build_phase(phase);

  //create an instance of the analysis port
  mon_analysis_port = new ("mon_analysis_port", this);

  //get virtual interface handle from the configuration_db
  if(!uvm_config_db #(virtual i2s_uvc_interface) :: get(this, "", "i2s_vif", i2s_vif)) begin
    `uvm_error(get_type_name(), "DUT interface not found")
  end
endfunction

virtual task run_phase (uvm_phase phase);
  i2s_seq_item i2s_data_obj = i2s_seq_item::type_id::create("i2s_data_obj", this);
  forever begin
    fork
    //change WS to left channel package
    @(negedge i2s_vif.WS) begin
      ->left_channel_select;
      //send LSB of right channel to data_right
      data_right_ = {data_right_[30:0], i2s_vif.TD};
      //start to write in left channel
      while(!i2s_vif.WS) begin
        repeat(1) @ (negedge i2s_vif.TCLK);
        data_left_ = {data_left_[30:0], i2s_vif.TD};
      end
    end
    @(posedge i2s_uvc.WS) begin
      ->right_channel_select;
      //send LSB of left channel lo data_left
      data_left_ = {data_left_[30:0], i2s_vif.TD};
