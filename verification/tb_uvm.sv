//testbench with UVM
//author: astrakhov, JSC MERI
//date: 05.11.2021
`timescale  1ns / 1ns


module tb_uvm;

  logic clk = 1;
  logic nrst = 1;

  always #0.5 clk = ~clk;



endmodule
