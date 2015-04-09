import svunit_pkg::*;
`include "svunit_defines.svh"

import uvm_pkg::uvm_object;

class uvm_object_mock extends uvm_object;
  function new(string name);
    super.new(name);
  endfunction
endclass


module uvm_object_unit_test;
  string name = "uvm_object_ut";
  svunit_testcase svunit_ut;

  uvm_object_mock uut;


  function void build();
    svunit_ut = new(name);

    uut = new("uut");
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

  `SVUNIT_TESTS_END

endmodule
