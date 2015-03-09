import svunit_pkg::*;
`include "svunit_defines.svh"


import uvm_pkg::uvm_reg;
import uvm_pkg::uvm_reg_field;
import uvm_pkg::UVM_NO_COVERAGE;


class uvm_reg_mock extends uvm_reg;
  uvm_reg_field field;
  
  function new(string name);
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();
    field = new("field");
    field.configure(this, 4, 0, "RW", 0, 4'h0, 1, 0, 0);
  endfunction
endclass


module uvm_reg_unit_test;

  string name = "uvm_reg_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_reg_mock my_reg;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    my_reg = new("my_reg");
    my_reg.build();
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    my_reg.field.set_compare();
    void'(my_reg.field.set_access("RW"));
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

    `SVTEST(do_check__exp_matches_actual__passes)
      `FAIL_UNLESS(my_reg.do_check('hdead_beef, 'hdead_beef, null) == 1);
    `SVTEST_END
    
    
    `SVTEST(do_check__field_mismatch__fails)
      `FAIL_UNLESS(my_reg.do_check('hf, 'h0, null) == 0);
    `SVTEST_END
    
    
    `SVTEST(do_check__unchecked_field_mismatch__passes)
      my_reg.field.set_compare(uvm_pkg::UVM_NO_CHECK);
      `FAIL_UNLESS(my_reg.do_check('hf, 'h0, null) == 1);
    `SVTEST_END
    
    
    `SVTEST(do_check__write_only_field_mismatch__passes)
      void'(my_reg.field.set_access("WO"));
      `FAIL_UNLESS(my_reg.do_check('hf, 'h0, null) == 1);
    `SVTEST_END
    
    
    `SVTEST(do_check__unmodeled_field_mismatch__passes)
      `FAIL_UNLESS(my_reg.do_check('hf0, 'h0, null) == 1);
    `SVTEST_END
    
  `SVUNIT_TESTS_END

endmodule
