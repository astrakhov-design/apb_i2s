//testbench without UVM
//author: astrakhov, JSC MERI
//date: 28.10.2021
`timescale 1ns / 1ns

`include "apb_interface.sv"
`include "i2s_interface.sv"

`include "register_defs.svh"

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

  APB_BUS      apb_slave();
  i2s_interface i2s_slave();

/* interconnection */
apb_i2s DUT(
  .i_clk(clk),
  .i_rst_n(nrst),
  .apb_slave(apb_slave),
  .i2s_master(i2s_slave)
);

`include "apb_tasks.sv"

bit [31:0]  apb_data_out;
bit [31:0]  apb_data_in;
//simple test for I/O registers
initial begin
  repeat(50) @ (posedge clk);
  //CHECK SR REGISTER
  read_apb(`SR_ADDR, apb_data_out);
  assert(apb_data_out[3:0] == 4'b1010) else
    $error("SR register is incorrect!");
  repeat(5) @ (posedge clk);
  apb_data_in = $urandom;
  write_apb(`TXR_ADDR, apb_data_in);
  //check if SR_reg.fifor_empty equals 0
  read_apb(`SR_ADDR, apb_data_out);
  apb_data_in = $urandom;
  assert(apb_data_out[3:0] == 4'b0010) else
    $error("SR register is incorrect!");
  write_apb(`TXL_ADDR, apb_data_in);
  //check if SR_reg.fifol_empty equals 0
  read_apb(`SR_ADDR, apb_data_out);
  assert(apb_data_out[3:0] == 4'b0000) else
    $error("SR register is incorrect!");
  repeat(20) @ (posedge clk);
  write_apb(`CR_ADDR, 32'h1);
  repeat(2000) @ (posedge clk);
	//check if CR.I2S_ENALBE is empty
	read_apb(`CR_ADDR, apb_data_out);
	assert(apb_data_out == 'h0) else
		$error("SR register is incorrect!");
	repeat(5) @ (posedge clk);
  apb_data_in = $urandom;
  write_apb(`TXR_ADDR, apb_data_in);
  apb_data_in = $urandom;
  write_apb(`TXL_ADDR, apb_data_in);
	repeat(5) @ (posedge clk);
  apb_data_in = $urandom;
  write_apb(`TXR_ADDR, apb_data_in);
  apb_data_in = $urandom;
  write_apb(`TXL_ADDR, apb_data_in);
	repeat(5) @ (posedge clk);
  apb_data_in = $urandom;
  write_apb(`TXR_ADDR, apb_data_in);
  apb_data_in = $urandom;
  write_apb(`TXL_ADDR, apb_data_in);
	repeat(5) @ (posedge clk);
  apb_data_in = $urandom;
  write_apb(`TXR_ADDR, apb_data_in);
  apb_data_in = $urandom;
  write_apb(`TXL_ADDR, apb_data_in);
	repeat(20) @ (posedge clk);
  write_apb(`CR_ADDR, 32'h1);
  repeat(2000) @ (posedge clk);
    $stop;
end



endmodule
