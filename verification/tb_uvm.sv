//testbench with UVM
//author: astrakhov, JSC MERI
//date: 05.11.2021

`include "uvm_macros.svh"
`include "test_pkg.sv"

module tb_uvm;

  import uvm_pkg::*;
  import test_pkg::*;

  logic clk   = 0;
  logic nrst  = 0;

  always #0.5 clk = ~clk;

  //reset scheme
    initial begin
                @(negedge clk); nrst <= 0;
      repeat(5) @(negedge clk); nrst <= 1;
    end

//declare RTL interfaces
  i2s_interface i2s_if();
  APB_BUS       apb_slave();

//declare UVM interfaces
  i2s_uvc_interface i2s_vif(.TCLK(i2s_if.TCLK));
  apb_interface     apb_if_uvc(clk);

//interconnection between interfaces
  assign apb_slave.paddr    = apb_if_uvc.paddr;
  assign apb_slave.pwdata   = apb_if_uvc.pwdata;
  assign apb_slave.pwrite   = apb_if_uvc.pwrite;
  assign apb_slave.psel     = apb_if_uvc.psel;
  assign apb_slave.penable  = apb_if_uvc.penable;
  assign apb_if_uvc.prdata  = apb_slave.prdata;
  assign apb_if_uvc.pready  = apb_slave.pready;
  assign apb_if_uvc.pslverr = apb_slave.pslverr;

  assign i2s_vif.WS      = i2s_if.WS;
  assign i2s_vif.TD      = i2s_if.TD;

/* interconnection */
  apb_i2s DUT(
    .i_clk(clk),
    .i_rst_n(nrst),
    .apb_slave(apb_slave),
    .i2s_master(i2s_if)
  );

//---------------------------
  initial begin
    $timeformat(-12, 0, " ps",10);
    uvm_config_db#(virtual apb_interface)::set(uvm_root::get(),"*","apb_if",apb_if_uvc);
    uvm_config_db#(virtual i2s_uvc_interface)::set(uvm_root::get(),"*","i2s_vif",i2s_vif);
  end

  initial begin
    run_test();
  end



endmodule
