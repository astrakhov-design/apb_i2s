//I2S master transmitter
//author: astrakhov, JSC MERI
//date: 26.10.2021

module i2s_master(
  input logic clk,
  input logic nrst,
  input logic enable,
  input logic [31:0]  data_left,
  input logic [31:0]  data_right,

  output logic        data_rqst,
	output logic				tx_done,

  output logic        tclk,
  output logic        ws,
  output logic        td
);

//simple prescaler to 4
logic [2:0] tclk_counter;
logic       tclk_prefall;

always_ff @ (posedge clk, negedge nrst)
  if(!nrst)
    tclk_counter  <=  'h0;
  else if (enable)
    tclk_counter  <=  tclk_counter + 1'b1;
	else
		tclk_counter	<=	'h0;

assign tclk_prefall = (tclk_counter == 'h7);
assign tclk         = enable ? tclk_counter[2] : 1'b1;

logic [5:0] bit_cntr;
logic [63:0] shift_reg;

logic ws_reg;

always_ff @ (posedge clk, negedge nrst) begin
  if(!nrst) begin
    bit_cntr  <=  'h0;
    shift_reg <=  'h0;
  end
  else begin
    if(enable) begin
      if(tclk_prefall) begin
        bit_cntr  <=  bit_cntr + 1'b1;
        if(bit_cntr == 'h0)
          shift_reg <= {data_left, data_right};
        else
          shift_reg <= shift_reg << 1;
      end
		end
		else begin
			bit_cntr	<=	'h0;
			shift_reg	<=	'h0;
    	end
  end
end

/*
always_ff @ (posedge clk, negedge nrst) begin
  if(!nrst)
    ws_reg  <=  1'b1;
  else begin
    if(enable)
        ws_reg <= bit_cntr[5];
    else
        ws_reg <= 1'b1;
  end
end
*/


assign ws = enable ? bit_cntr[5] : 1'b1;
assign td = shift_reg[63];
assign data_rqst = (tclk_counter == 'h6) && (bit_cntr == 'd63) && enable && ws;
assign tx_done = (tclk_counter == 'h0) && (bit_cntr == 'h01) && !ws;

endmodule
