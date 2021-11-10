//TCLK BEHAVIOUR OSCILLATOR
//AUTHOR: ASTRAKHOV, JSC MERI
//DATE: 10.11.2021

module tclk_oscillator #(
  parameter TCLK_PERIOD = 25)
( 
  output logic tclk);
  
initial begin
  tclk = 0;
end
  
always #(TCLK_PERIOD) tclk = ~tclk;

endmodule
