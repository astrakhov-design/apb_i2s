//interface module for APB bus
//author: astrakhov, JSC MERI
//date: 25.10.2021
interface apb_interface #(
  parameter int unsigned  APB_ADDR_WIDTH  = 32,
  parameter int unsigned  APB_DATA_WIDTH  = 32
) (
  input clk
);

logic [APB_ADDR_WIDTH-1:0]   	paddr;
logic                       	psel;
logic                       	pwrite;
logic [APB_DATA_WIDTH-1:0]   	pwdata;
logic                       	penable;
logic                       	pready;
logic  [APB_DATA_WIDTH-1:0]  	prdata;
logic                       	pslverr;

modport Master(
  output paddr, pwdata, pwrite, psel, penable,
  input  prdata, pready, pslverr
);

modport Slave(
  input   paddr, pwdata, pwrite, psel, penable,
  output  prdata, pready, pslverr
);

modport out(
  output paddr, pwdata, pwrite, psel, penable,
  input  prdata, pready, pslverr
);

modport in(
  input   paddr, pwdata, pwrite, psel, penable,
  output  prdata, pready, pslverr
);

endinterface
