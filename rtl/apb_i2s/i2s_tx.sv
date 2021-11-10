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
  
//input WS and SCLK
  input logic         i_tclk,
  input logic         i_ws,

//output system signals
  output logic        data_rqst,

//output signals
  output logic        o_tclk,
  output logic        o_ws,
  output logic        o_td
);

logic tclk_negedge;
logic tclk_posedge;
logic wsel_negedge;
logic wsel_sync;

logic load_words;

logic [5:0]   bit_cntr;
logic [63:0]  shift_reg;

logic [1:0] rqst_cntr;  

//sync tclk
signal_sync sync_tclk(
  .clk      (i_clk        ),
  .nrst     (i_nrst       ),
  .i_signal (i_tclk       ),
  .o_signal (             ),
  .o_valid  (             ),
  .o_edge   (             ),
  .o_posedge(tclk_posedge ),
  .o_negedge(tclk_negedge )
);

//sync ws
signal_sync sync_ws(
  .clk      (i_clk         ),
  .nrst     (i_nrst        ),
  .i_signal (i_ws          ),
  .o_signal (wsel_sync     ),
  .o_valid  (              ),
  .o_edge   (              ),
  .o_posedge(              ),
  .o_negedge(wsel_negedge  )
);

assign  load_words  = i_enable && (bit_cntr == 'h0) && tclk_negedge;
assign  data_rqst   = i_enable && (bit_cntr == 'h0) && tclk_posedge && (rqst_cntr != 0);
assign  o_td        = shift_reg[63];
assign  o_ws        = wsel_sync;
assign  o_tclk      = i_tclk;

//data request counter
always_ff @ (posedge i_clk, negedge i_nrst) begin
  if(!i_nrst)
    rqst_cntr <=  'h0;
  else begin
    if(i_enable && (bit_cntr == 'h1) && tclk_posedge)
      rqst_cntr <= rqst_cntr + 1'b1;
    else if(!i_enable && (rqst_cntr != 0))
      rqst_cntr <= 2'b00;
      
    if(rqst_cntr == 2'b11)
      rqst_cntr <=  2'b01;
  end
end

always_ff @ (posedge i_clk, negedge i_nrst) begin
  if(!i_nrst)
    bit_cntr  <=  'h0;
  else if (i_enable) begin
    if(wsel_negedge)
      bit_cntr  <=  'h0;
    else if(tclk_negedge)
      bit_cntr  <=  bit_cntr - 1'b1;
  end
end

always_ff @ (posedge i_clk, negedge i_nrst) begin
  if(!i_nrst)
    shift_reg <=  'h0;
  else if (i_enable) begin
    if(load_words)
      shift_reg <=  {i_data_left, i_data_right};
    else if(tclk_negedge)
      shift_reg <=  shift_reg << 1;
  end
end

endmodule
