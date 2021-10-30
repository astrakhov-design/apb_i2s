//APB_I2S HEAD MODULE
//author: astrakhov, JSC MERI
//date: 25.10.2021
`define FIFO_DEPTH  2

`include "register_map.sv"


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
    end
    else begin
      if (wr) begin
        case(addr)
          CR_ADDR:  begin
                      CR  <=  wdata[0];
                    end
        endcase
      end
    end
  end

/* TXL pseudo register logic */
  logic txl_write;
  assign txl_write = (addr == TXL_ADDR) && wr;

  logic [31:0] txl_bus;
  assign txl_bus = txl_write ? wdata : 'h0;

/* TXR pseudo register logic */
  logic txr_write;
  assign txr_write = (addr == TXR_ADDR) && wr;

  logic [31:0]  txr_bus;
  assign txr_bus = txr_write ? wdata : 'h0;

  logic         buffer_read;
  logic [31:0]  txl_out;
  logic [31:0]  txr_out;

/*Module interconnection */

/* FIFO buffer for Left Channel */
fifo_buffer #(
  .B(32),
  .W(FIFO_DEPTH)
) fifo_txl(
  .clk(i_clk),
  .rst(i_rst_n),
  .rd(buffer_read),
  .wr(txl_write),
  .w_data(txl_bus),
  .empty(SR.fifol_empty),
  .full(SR.fifol_full),
  .r_data(txl_out)
);

/* FIFO buffer for Right Channel */
fifo_buffer #(
  .B(32),
  .W(FIFO_DEPTH),
) fifo_txr(
  .clk(i_clk),
  .rst(i_rst_n),
  .rd(buffer_read),
  .wr(txr_write),
  .w_data(txr_bus),
  .empty(SR.fifor_emprty),
  .full(SR.fifor_full),
  .r_data(txr_out)
);

/* i2s master module */
i2s_master i2s_tx(
  .clk(clk),
  .nrst(nrst),
  .enable(CR.I2S_ENABLE),
  .data_left(txl_out),
  .data_right(txr_out),
  .data_rqst(buffer_read),
  .tclk(i2s_master.TCLK),
  .ws(i2s_master.WS),
  .td(i2s_master.TD)
);

endmodule