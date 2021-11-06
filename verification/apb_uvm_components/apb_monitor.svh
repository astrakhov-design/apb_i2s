class apb_monitor extends uvm_monitor;

  virtual apb_interface apb_if;
  uvm_analysis_port #(apb_seq_item) item_collected_port;
  apb_seq_item  trans_collected;

  `uvm_component_utils(apb_monitor)

  function new (string name, uvm_component parent = null);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this,"","apb_if",apb_if))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".apb_if"});
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    begin
      forever begin
        @(posedge apb_if.clk);
        if(apb_if.psel & apb_if.penable & apb_if.pready)
          begin
            if(apb_if.pwrite)
              begin
                trans_collected.rw_data = apb_if.pwdata;
                trans_collected.addr    = apb_if.paddr;
                trans_collected.we      = 1;
              end
            else begin
                trans_collected.rw_data = apb_if.prdata;
                trans_collected.addr    = apb_if.paddr;
                trans_collected.we      = 0;
              end
            item_collected_port.write(trans_collected);
        end
      end
    end
  endtask : run_phase

endclass : apb_monitor
