class apb_scb extends uvm_scoreboard;

  `uvm_component_utils(apb_scb)
  `uvm_analysis_imp_decl(_apb)

  uvm_analysis_imp_apb#(apb_seq_item, apb_scb) item_collected_export_apb;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  apb_seq_item pkt_qu[$];
  logic [31:0]  payload_exp_qu[$]; //test can put here data for comparison
  logic [31:0]  payload_msk_qu[$]; //payload mask

  bit comp_enable;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export_apb = new("item_collected_export_apb", this);
  endfunction : build_phase

  //write task
  virtual function void write_apb(apb_seq_item pkt);
    if(comp_enable)
      pkt_qu.push_back(pkt);
  endfunction : write_apb

  //run_phase
  virtual task run_phase(uvm_phase phase);
    apb_seq_item apb_pkt;
    logic [31:0]  payload_exp;
    logic [31:0]  payload_mask;
    forever begin
//      if(comp_enable) begin
      wait(pkt_qu.size() > 0);
      if(pkt_qu.size() > 0) begin
        apb_pkt = pkt_qu.pop_front();
        if((~apb_pkt.we) & (payload_exp_qu.size() == 0))
          `uvm_warning(get_type_name(), $sformatf("Warning! No expected data!"))
        else begin
          payload_exp = payload_exp_qu.pop_front();
          if(payload_msk_qu.size() > 0) begin
            payload_mask = payload_msk_qu.pop_front();
            `uvm_info(get_type_name(), $sformatf("Payload mask will be applied to recieved and expected data! mask = %8h", payload_mask), UVM_HIGH)
            apb_pkt.rw_data = apb_pkt.rw_data & payload_mask;
            payload_exp     = payload_exp     & payload_mask;
          end
          if(~apb_pkt.we)
            if(apb_pkt.rw_data == payload_exp)
              `uvm_info(get_type_name(), $sformatf("Payload = %8h OK", apb_pkt.rw_data),  UVM_HIGH)
            else begin
              `uvm_error(get_type_name(), $sformatf("Error! Payload = %8h does not match (expected %8h)", apb_pkt.rw_data, payload_exp));
              $stop;
            end
        end
      end
    end
  endtask : run_phase

endclass : apb_scb
