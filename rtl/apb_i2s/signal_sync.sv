//signal sync module
//author: astrakhov, JSC MERI

module signal_sync(
  input   logic clk,
  input   logic nrst,
  
  input   logic i_signal,
  
  output  logic o_signal,
  output  logic o_valid,
  output  logic o_edge,
  output  logic o_posedge,
  output  logic o_negedge
);

logic [2:0] stage;

assign  o_valid   = (stage[0] == stage[1]);
assign  o_edge    = (stage[1] !=  stage[2]) && o_valid;
assign  o_posedge = (stage[1] && !stage[2]) && o_valid;
assign  o_negedge = (!stage[1] && stage[2]) && o_valid;
assign  o_signal  = stage[1];

always_ff @ (posedge clk, negedge nrst) begin
  if(!nrst)
    stage <=  'h0;
  else
    stage <= {stage[1:0], i_signal};
end

endmodule
  
