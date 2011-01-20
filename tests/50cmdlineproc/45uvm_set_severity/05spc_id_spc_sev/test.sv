program top;

import uvm_pkg::*;
`include "uvm_macros.svh"

// This test needs lots of messaging and checks for correct actions.

class test extends uvm_test;

   bit pass_the_test = 1;

   `uvm_component_utils(test)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual task run();
      `uvm_error("A", "A Error but downgrading to an Info!!!")
      #1000;
      uvm_top.stop_request();
   endtask

   virtual function void report();
     uvm_report_server rs = uvm_report_server::get_server();
     if((rs.get_id_count("A") == 1) && (rs.get_severity_count(UVM_ERROR) == 0))
       $write("** UVM TEST PASSED **\n");
   endfunction

endclass


initial
  begin
     run_test();
  end

endprogram
