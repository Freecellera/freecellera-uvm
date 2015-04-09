import svunit_pkg::*;
`include "svunit_defines.svh"

//import uvm_pkg::uvm_object;
import uvm_pkg::UVM_STREAMBITS;
import uvm_pkg::uvm_bitstream_t;
import uvm_pkg::uvm_vector_to_string;
import uvm_pkg::UVM_DEC;

module uvm_misc_unit_test;
  string name = "uvm_misc_ut";
  svunit_testcase svunit_ut;

  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

  // test a few negative numbers of varying size (mantis 4601)
  `SVTEST(signed_vector_to_string_4bit_minus1)
    string s_exp = "-1";
    string s_act = uvm_vector_to_string ('hf, 4, UVM_DEC, "j");
    `FAIL_IF(s_act != s_exp);
  `SVTEST_END

  `SVTEST(signed_vector_to_string_MAXbit_minus2)
    string s_exp = "-2";
    uvm_bitstream_t minus2 = -2;
    string s_act = uvm_vector_to_string (minus2, UVM_STREAMBITS, UVM_DEC, "j");
    `FAIL_IF(s_act != s_exp);
  `SVTEST_END

  `SVTEST(signed_vector_to_string_100bit_minus3)
    string s_exp = "-3";
    bit[99:0] minus3 = -3;
    string s_act = uvm_vector_to_string (minus3, 100, UVM_DEC, "j");
    `FAIL_IF(s_act != s_exp);
  `SVTEST_END

  // test a positive number to make sure they're still returned correctly (mantis 4601)
  `SVTEST(signed_vector_to_string_32bit_plus1)
    string s_exp = "1";
    bit[31:0] plus1 = 1;
    string s_act = uvm_vector_to_string (plus1, 32, UVM_DEC);
    `FAIL_IF(s_act != s_exp);
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
