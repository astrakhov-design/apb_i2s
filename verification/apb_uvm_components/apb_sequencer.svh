class apb_sequencer extends uvm_sequencer#(apb_seq_item);

  `uvm_component_utils(apb_seq_sequencer)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunciton

endclass
