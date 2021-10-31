//interface module for APB bus
//author: astrakhov, JSC MERI
//date: 25.10.2021
interface APB_BUS #(
  parameter int unsigned  APB_ADDR_WIDTH  = 32,
  parameter int unsigned  APB_DATA_WIDTH  = 32
);

logic [APB_ADDR_WIDTH:0]   paddr;
logic                       psel;
logic                       pwrite;
logic [APB_DATA_WIDTH:0]   pwdata;
logic                       penable;
logic                       pready;
logic  [APB_DATA_WIDTH:0]  prdata;
logic                       pslverr;

modport Master(
  output paddr, pwdata, pwrite, psel, penable,
  input  prdata, pready, pslverr
);

modport Slave(
  input   paddr, pwdata, pwrite, psel, penable,
  output  prdata, pready, pslverr
);

endinterface
