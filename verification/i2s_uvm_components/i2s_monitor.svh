//i2s monitor class
//author: astrakhov, JSC MERI
//date: 31.10.2021

class i2s_monitor extends uvm_monitor;
  `uvm_component_utils(i2s_monitor)

  virtual i2s_uvc_interface i2s_vif;

  event recording_started;
  event recording_command;
  event recording_finished;
  
  event right_recording;

  bit [31:0] data_left_;
  bit [31:0] data_right_;
  int  bit_cntr_left;
  int  bit_cntr_right;

  uvm_analysis_port # (i2s_seq_item) i2s_mon_analysis_port;

  //plaseholder to capture transaction info
  i2s_seq_item trans_collected;

  //Constructor for this class
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
//    transaction_counter = 0;
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
  bit_cntr_left     = 0;
  bit_cntr_right    = 0;
  forever begin
    @(posedge i2s_vif.TCLK);
     fork
      @(negedge i2s_vif.WS) begin //catch WS negedge pulse
        bit_cntr_left   = 0;
        ->recording_started;
        while(!i2s_vif.WS && (bit_cntr_left <= 31)) begin
          repeat(1) @ (posedge i2s_vif.TCLK);
          data_left_ = {data_left_[30:0], i2s_vif.TD};
          bit_cntr_left++;
        end
      end
      @(posedge i2s_vif.WS) begin //catch WS posedge pulse
        bit_cntr_right  = 0;
        ->right_recording;
        while(i2s_vif.WS && (bit_cntr_right <= 31)) begin
          repeat(1) @ (posedge i2s_vif.TCLK);
          data_right_ = {data_right_[30:0], i2s_vif.TD};
          bit_cntr_right++;
        end
        trans_collected.data_left = data_left_;
        trans_collected.data_right = data_right_;
        i2s_mon_analysis_port.write(trans_collected);
        ->recording_finished;        
        trans_collected.print();
      end
     join_any
  end
endtask

endclass
