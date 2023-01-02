//register map for apb_i2s
//author: astrakhov
//date: 25.10.2021

package register_pkg;

//address map
  typedef enum logic [1:0] {
    CR_ADDR = 2'b00,
    SR_ADDR = 2'b01,
    TXR_ADDR = 2'b10,
    TXL_ADDR = 2'b11
  } address_map;

//COMMAND REGISTER
  typedef struct packed {
    logic [30:0]  RESERVED;
    logic         I2S_ENABLE;
  } CR_reg;

//STATE REGISTER
  typedef struct packed {
    logic [26:0]  RESERVED;
  	logic		      i2s_tx_done;
    logic         fifor_empty;
    logic         fifor_full;
    logic         fifol_empty;
    logic         fifol_full;
  } SR_reg;

//DATA REGISTER FOR RIGHT CHANNEL
  typedef struct packed {
    logic [31:0] data_right;
  } TXR_reg;

//DATA REGISTER FOR LEFT CHANNEL
  typedef struct packed {
    logic [31:0] data_left;
  } TXL_reg;

endpackage
