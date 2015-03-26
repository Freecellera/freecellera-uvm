import svunit_pkg::*;
`include "svunit_defines.svh"

//import uvm_pkg::uvm_object;
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

  `SVTEST(signed_vector_to_string)
    string s_exp = "-1";
    string s_act = uvm_vector_to_string ('hf, 4, UVM_DEC, "j");
    `FAIL_IF(s_act != s_exp);
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
