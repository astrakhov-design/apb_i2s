//i2s_interface passive agent
//author: astrakhov, JSC MERI
//date: 05.11.2021
class i2s_agent extends uvm_agent;
  `uvm_component_utils(i2s_agent)

  i2s_monitor i2s_monitor;

  funciion new (string name = "i2s_agent", uvm_componenet_parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    i2s_monitor = i2s_monitor::type_id::create("i2s_monitor", this);
  endfunction

endclass
