// 
// -------------------------------------------------------------
//    Copyright 2004-2009 Synopsys, Inc.
//    All Rights Reserved Worldwide
// 
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
// 


class wb_sequencer extends uvm_sequencer #(wb_cycle);
   `uvm_sequencer_utils(wb_sequencer)

   function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
      `uvm_update_sequence_lib_and_item(wb_cycle)
   endfunction
endclass


class wb_agent extends uvm_agent;

   uvm_active_passive_enum is_active;

   wb_driver     drv;
   // wb_monitor   mon;
   wb_sequencer seqr;

   `uvm_component_utils_begin(wb_agent)
   `uvm_component_utils_end

   function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
      is_active = UVM_ACTIVE;
   endfunction

   virtual function void build_phase();
      // mon  = wb_monitor::type_id::create("mon", this);
      if (this.is_active == UVM_ACTIVE) begin
         drv  = wb_driver::type_id::create("drv", this);
         seqr = wb_sequencer::type_id::create("seqr", this);
      end
   endfunction

   virtual function void connect_phase();
      if (drv != null && seqr != null) begin
         drv.seq_item_port.connect(seqr.seq_item_export);
      end
   endfunction
endclass
