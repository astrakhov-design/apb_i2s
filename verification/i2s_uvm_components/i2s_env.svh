//i2s uvm environment
//author: astrakhov, JSC MERI
//date: 05.11.2021

class i2s_env extends uvm_env;
  `uvm_component_utils(i2s_env)

  i2s_agent i2s_agent;

  function new(string name = "i2s_env", uvm_component_parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    i2s_agent = i2s_agent::type_id::create("i2s_agent", this);

  endfunction

endclass
