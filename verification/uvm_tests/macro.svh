/*
`define i2s_rcv(data_left, data_right) \
  begin \
    i2s_env_i.i2s_scb_i.data_left_exp_qu.push_back(data_left); \
    i2s_env_i.i2s_scb_i.data_right_exp_qu.push_back(data_right); \
    @(i2s_env_i.i2s_scb_i.complete_trans); \
  end
*/
  
`define apb_write(addr, data_) \
  begin \
    apb_wr_i.wr_seq_rw_data = data_;
    apb_env_i.apb_scb_i.payload_exp_qu.push_back(data_); \
    apb_wr_i.wr_seq_addr = addr; \
    apb_wr_i.start(apb_env_i.apb_agent_i.sequencer); \
  end
