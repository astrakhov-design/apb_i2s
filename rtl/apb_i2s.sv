//APB_I2S HEAD MODULE
//author: astrakhov, JSC MERI
//date: 25.10.2021

module apb_i2s(
  input logic i_clk,
  input logic i_rst_n,

  APB_BUS.Slave apb_slave,
  i2s_interface.Master i2s_master
);

/* REGISTER MAP */
import register_map::*;

address_map addr;
CR_reg      CR;
SR_reg      SR;
TXR_reg     TXR;
TXL_reg     TXL;

/* Native interface for access to register */
logic         rd;
logic         rd_done;
logic         wr;
logic [31:0]  wdata;
logic [31:0]  rdata;

assign wr               = apb_slave.psel    &
                          apb_slave.penable &
                          apb_slave.pwrite;

assign rd               = apb_slave.psel    &
                          apb_slave.penable &
                          ~apb_slave.pwrite;

assign rd_done          = apb_slave.psel    &
                          apb_slave.penable &
                          ~apb_slave.pwrite &
                          apb_slave.pready;

assign addr             = address_map'(apb_slave.paddr[5:2]);

assign wdata            = apb_slave.pwdata;
assign apb_slave.prdata = rdata;

assign apb_slave.pslverr =  1'b0;
assign apb_slave.pready  =  1'b1;

/* read registers by SW */
  always_comb begin
    rdata = 0;
    if(rd) begin
      case(addr)
        CR_ADDR: rdata = CR;
        SR_ADDR: rdata = SR;
      endcase
    end
    else
      rdata = 'h0;
  end

/* Write registers by SW */
  always_ff @ (posedge i_clk, negedge i_rst_n) begin
    if(~i_rst_n) begin
      CR  <=  'h0;
      TXR <=  'h0;
      TXL <=  'h0;
    end
    else begin
      if (wr) begin
        case(addr)
          CR_ADDR:  begin
                      CR  <=  wdata[0];
                    end
          TXL_ADDR: begin
                      TXL <=  wdata;
                    end
          TXR_ADDR: begin
                      TXR <=  wdata;
                    end
        endcase
      end
    end
  end

/*Module interconnection */
