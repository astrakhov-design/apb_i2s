class apb_agent extends uvm_agent;
  apb_driver    driver;
  apb_sequencer sequencer;
  apb_monitor   monitor;

  `uvm_component_utils(apb_agent)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active() == UVM_ACTIVE) begin
      driver = apb_driver::type_id::create("driver", this);
      sequencer = apb_sequencer::type_id::create("sequencer", this);
    end

    monitor = apb_monitor::type_id::create("monitor", this);

  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : apb_agent
