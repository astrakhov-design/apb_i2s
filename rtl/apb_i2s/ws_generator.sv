//WSEL GENERATOR
//AUTHOR: ASTRAKHOV, JSC MERI
//DATE: 10.11.2021

module ws_generator (
  input logic i_tclk,
  input logic i_nrst,
  input logic i_enable,
  
  output logic  o_ws
);

logic [4:0] indx_bit;

always_ff @ (negedge i_tclk, negedge i_nrst) begin
  if(!i_nrst) begin
    o_ws      <=  1'b0;
    indx_bit  <=  5'd0;
  end
  else if(i_enable) begin
    if(indx_bit == 5'd1)
      o_ws  <=  ~o_ws;
      
    if(indx_bit == 0)
      indx_bit  <=  5'd31;
    else
      indx_bit  <=  indx_bit - 1'b1;
  end
end

endmodule    
