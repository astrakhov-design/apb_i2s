//task definition file
//author: astrakhov, agordienko, JSC MERI

//write apb task
task write_apb (
  input bit [31:0]  address,
  input bit [31:0]  data,
  input       display_flag = 0
);

  @(posedge clk)
  apb_slave.paddr   <=  address;
  apb_slave.pwdata  <=  data;
  apb_slave.pwrite  <=  1'b1;
  apb_slave.psel    <=  1'b1;

  @(posedge clk)
  if(!display_flag) begin
    $display("write: addr 0x%8x, data 0x%8x",
                     apb_slave.paddr, apb_slave.pwdata);
  end

  apb_slave.penable <=  1'b1;
  @(posedge clk)
  while(apb_slave.pready == 1'b0) begin
    @(posedge clk);
  end

  apb_slave.psel    <=  1'b0;
  apb_slave.penable <=  1'b0;
  apb_slave.pwrite  <=  1'b0;

endtask

//read apb task
task read_apb(
  input [31:0]  address,
  output [31:0] data,
  input         display_flag = 0
);

  @(posedge clk)
  apb_slave.paddr   <=  address;
  apb_slave.pwrite  <=  1'b0;
  apb_slave.psel    <=  1'b1;

  @(posedge clk)
  apb_slave.penable <=  1'b1;
  @(posedge clk)
  while(apb_slave.pready == 1'b0) begin
      @(posedge clk);
  end

  data = apb_slave.prdata;
  if(!display_flag) begin
    $display("  read: addr 0x%8x, data 0x%8x",
                address, apb_slave.prdata);
  end

  apb_slave.psel    <=  1'b0;
  apb_slave.penable <=  1'b0;

endtask
