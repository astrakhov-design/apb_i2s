//register map for apb_i2s
//author: astrakhov
//date: 25.10.2021

package register_map;

//address map
  typedef enum logic [1:0] {
    CR_ADDR,
    SR_ADDR,
    TXR_ADDR,
    TXL_ADDR
  } address_map;

//COMMAND REGISTER
  typedef struct packed {
    logic [30:0]  RESERVED;
    logic         I2S_ENABLE;
  } CR_reg;

//STATE REGISTER
  typedef struct packed {
    logic [27:0]  RESERVED;
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
