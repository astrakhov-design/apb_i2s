//test package
//author: astrakhov, JSC MERI
`timescale  1ns / 1ps

`include "../i2s_uvm_components/i2s_pkg.svh"

package test_pkg;
  import uvm_pkg::*;
  import i2s_pkg::*;

  `include "uvm_macros.svh"
  `include "test_standalone"

endpackage
