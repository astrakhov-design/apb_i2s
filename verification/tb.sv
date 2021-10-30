//testbench without UVM
//author: astrakhov, JSC MERI
//date: 28.10.2021
`timescale 1ns / 1ns

module tb;
  logic clk   = 1;
  logic nrst  = 1;

  always #0.5 clk = ~clk;

  initial begin
    @(negedge clk);
    nrst  <= 0;
    repeat(5) @ (negedge clk);
    nrst  <= 1;
  end

  APB_BUS.Master      apb_master;
  i2s_interface.Slave i2s_slave;

/* interconnection */
apb_i2s DUT(
  .i_clk(clk),
  .i_rst_n(nrst),

  APB_BUS       apb_master,
  i2s_interface i2s_slave
);

task apb_send(
  input bit [31:0]  address,
  input bit [31:0]  data
);

endtask
