class apb_driver extends uvm_driver #(apb_seq_item);

  `uvm_component_utils(apb_driver)

  virtual apb_interface apb_if;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "","apb_if",apb_if))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".apb_if"});
  endfunction : build_phase

  function new (string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    begin
      apb_if.Master.psel    = 0;
      apb_if.Master.penable = 0;
      apb_if.Master.pwrite  = 0;
      apb_if.Master.paddr   = 0;
      forever begin
        seq_item_port.get(req);
        drive();
        seq_item_port.put(req);
      end
    end
  endtask : run_phase

//Driving logic
  virtual task drive();
    begin
      repeat(req.delay) @ (posedge apb_if.clk);
      //Setup phase
      if(req.we)
        apb_if.Master.pwdata <= req.rw_data;
      else begin
        apb_if.Master.pwdata <= 0;
      end

      apb_if.Master.paddr    <= req.addr;

    apb_if.Master.psel       <= 1;

      if(req.we)
        apb_if.Master.pwrite <= 1;
      else
        apb_if.Master.pwrite <= 0;
    //Access phase
      @(posedge apb_if.clk);
      apb_if.Master.penable  <= 1;

      @(negedge apb_if.clk);
      if(!req.we)
        req.rw_data <= apb_if.Master.prdata;

    //End of Message
      forever begin
        @(posedge apb_if.clk);
        if(!req.we)
          req.rw_data <= apb_if.Master.prdata;
        if(apb_if.pready)
          break;
      end

      apb_if.Master.pwdata  <=  0;
      apb_if.Master.paddr   <=  0;
      apb_if.Master.psel    <=  0;
      apb_if.Master.penable <=  0;
      apb_if.Master.pwrite  <=  0;
    end
  endtask : drive

endclass : apb_driver
