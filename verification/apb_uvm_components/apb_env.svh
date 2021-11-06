class apb_env extends uvm_env;

  apb_agent apb_agent_i;
  apb_scb   apb_scb_i;

  `uvm_component_utils(apb_env)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_agent_i = apb_agent::type_id::create("apb_agent_i", this);
    apb_scb_i   = apb_scb::type_id::create("apb_scb_i", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    apb_agent_i.monitor.item_collected_port.connect(apb_scb_i.item_collected_export_apb);
  endfunction : connect_phase

endclass : apb_env
