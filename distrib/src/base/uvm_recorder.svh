//
//-----------------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//-----------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: uvm_recorder
//
// The uvm_recorder class provides a policy object for recording <uvm_objects>.
// The policies determine how recording should be done. 
//
// A default recorder instance, <uvm_default_recorder>, is used when the
// <uvm_object::record> is called without specifying a recorder.
//
//------------------------------------------------------------------------------

class uvm_recorder;

  int recording_depth = 0; 


  // Variable: tr_handle
  //
  // This is an integral handle to a transaction object. Its use is vendor
  // specific. 
  //
  // A handle of 0 indicates there is no active transaction object. 

  integer tr_handle = 0;


  // Variable: default_radix
  //
  // This is the default radix setting if <record_field> is called without
  // a radix.

  uvm_radix_enum default_radix = UVM_HEX;


  // Variable: physical
  //
  // This bit provides a filtering mechanism for fields. 
  //
  // The <abstract> and physical settings allow an object to distinguish between
  // two different classes of fields. 
  //
  // It is up to you, in the <uvm_object::do_record> method, to test the
  // setting of this field if you want to use the physical trait as a filter.

  bit physical = 1;


  // Variable: abstract
  //
  // This bit provides a filtering mechanism for fields. 
  //
  // The abstract and physical settings allow an object to distinguish between
  // two different classes of fields. 
  //
  // It is up to you, in the <uvm_object::do_record> method, to test the
  // setting of this field if you want to use the abstract trait as a filter.

  bit abstract = 1;


  // Variable: identifier
  //
  // This bit is used to specify whether or not an object's reference should be
  // recorded when the object is recorded. 

  bit identifier = 1;


  // Variable: recursion_policy
  //
  // Sets the recursion policy for recording objects. 
  //
  // The default policy is deep (which means to recurse an object).

  uvm_recursion_policy_enum policy = UVM_DEFAULT_POLICY;


  // Function: record_field
  //
  // Records an integral field (less than or equal to 4096 bits). ~name~ is the
  // name of the field. 
  //
  // ~value~ is the value of the field to record. ~size~ is the number of bits
  // of the field which apply. ~radix~ is the <uvm_radix_enum> to use.

  virtual function void record_field (string name, 
                                      uvm_bitstream_t value, 
                                      int size, 
                                      uvm_radix_enum  radix=UVM_NORADIX);
    if(tr_handle==0) return;
    scope.set_arg(name);

    if(!radix)
      radix = default_radix;

    case(radix)
      UVM_BIN:     uvm_set_attribute_by_name(tr_handle, scope.get(), value, "'b",size);
      UVM_OCT:     uvm_set_attribute_by_name(tr_handle, scope.get(), value, "'o",size);
      UVM_DEC:     uvm_set_attribute_by_name(tr_handle, scope.get(), value, "'s",size);
      UVM_TIME:    uvm_set_attribute_by_name(tr_handle, scope.get(), value, "'u",size);
      UVM_STRING:  uvm_set_attribute_by_name(tr_handle, scope.get(), value, "'a",size);
      default: uvm_set_attribute_by_name(tr_handle, scope.get(), value, "'x",size);
    endcase
  endfunction


  // Function: record_field_real
  //
  // Records an real field. ~value~ is the value of the field to record. 

  virtual function void record_field_real (string name, 
                                           real value);
    bit[63:0] ival = $realtobits(value);
    if(tr_handle==0) return;
    scope.set_arg(name);
    uvm_set_attribute_by_name(tr_handle, scope.get(), ival, "'r");
  endfunction


  // Function: record_object
  //
  // Records an object field. ~name~ is the name of the recorded field. 
  //
  // This method uses the <recursion_policy> to determine whether or not to
  // recurse into the object.

  virtual function void record_object (string name, uvm_object value);
     int v;
    string str; 

    if(identifier) begin 
      if(value != null) begin
        $swrite(str, "%0d", value.get_inst_id());
        v = str.atoi(); 
      end
      scope.set_arg(name);
      uvm_set_attribute_by_name(tr_handle, scope.get(), v, "'s");
    end
 
    if(policy != UVM_REFERENCE) begin
      if(value!=null) begin
        if(value.m_sc.cycle_check.exists(value)) return;
        value.m_sc.cycle_check[value] = 1;
        scope.down(name);
        value.record(this);
        scope.up();
        value.m_sc.cycle_check.delete(value);
      end
    end

  endfunction


  // Function: record_string
  //
  // Records a string field. ~name~ is the name of the recorded field.
  
  virtual function void record_string (string name, string value);
    scope.set_arg(name);
    uvm_set_attribute_by_name(tr_handle, scope.get(), uvm_string_to_bits(value), "'a");
  endfunction


  // Function: record_time
  //
  // Records a time value. ~name~ is the name to record to the database.
  
  
  virtual function void record_time (string name, time value); 
    record_field(name, value, 64, UVM_TIME); 
  endfunction


  // Function: record_generic
  //
  // Records the ~name~-~value~ pair, where ~value~ has been converted
  // to a string. For example:
  //
  //| recorder.record_generic("myvar",$sformatf("%0d",myvar));
  
  virtual function void record_generic (string name, string value);
    record_string(name, value);
  endfunction


  uvm_scope_stack scope = new;

endclass



