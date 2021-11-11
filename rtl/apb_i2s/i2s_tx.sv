//I2S master transmitter
//author: astrakhov, JSC MERI
//date: 26.10.2021

module i2s_tx(
  input logic         i_clk,
  input logic         i_nrst,
  input logic         i_enable,
  
//data declaration
  input logic [31:0]  i_data_left,
  input logic [31:0]  i_data_right,
  
//output system signals
  output logic        data_rqst,

//output signals
  output logic        o_tclk,
  output logic        o_ws,
  output logic        o_td
);

assign o_tclk = i_clk;

logic [63:0]  shift_reg;
logic [5:0]   bit_cntr;

assign o_ws = ~bit_cntr[5];
assign o_td = shift_reg[63];
assign data_rqst = (bit_cntr == 'h1);

always @ (negedge o_tclk, negedge i_nrst) begin
  if(!i_nrst)
    bit_cntr  <=  'h0;
  else if(i_enable)
    bit_cntr  <=  bit_cntr - 1;
  else
    bit_cntr  <=  'h0;
end

always @ (negedge o_tclk, negedge i_nrst) begin
  if(!i_nrst)
    shift_reg <=  'h0;
  else if(i_enable) begin
    if(bit_cntr == 'h0)
      shift_reg <=  {i_data_left, i_data_right};
    else
      shift_reg <=  {shift_reg[62:0], 1'b0};
  end
end

endmodule
