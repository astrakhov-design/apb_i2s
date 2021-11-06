//i2s uvm environment
//author: astrakhov, JSC MERI
//date: 05.11.2021

class i2s_env extends uvm_env;
  `uvm_component_utils(i2s_env)

  i2s_agent i2s_agent_i;
  i2s_scb   i2s_scb_i;

  function new(string name = "i2s_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i2s_agent_i = i2s_agent::type_id::create("i2s_agent_i", this);
    i2s_scb_i   = i2s_scb::type_id::create("i2s_scb_i", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    i2s_agent_i.monitor.i2s_mon_analysis_port.connect(i2s_scb_i.item_collected_export_i2s);
  endfunction

endclass
