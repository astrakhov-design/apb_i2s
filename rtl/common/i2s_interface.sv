//I2S interface
//author: astrakhov, JSC MERI
//date: 25.10.2021

interface i2s_interface;

//clock signal
logic TCLK;
//wise select
logic WS;
//transmitt data
logic TD;

modport Master(
  output TCLK, WS, TD
);

modport Slave(
  input TCLK, WS, TD
);

endinterface
