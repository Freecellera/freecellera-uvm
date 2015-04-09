`include "svunit_defines.svh"


module uvm_reg_map_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "uvm_reg_map_ut";
  svunit_testcase svunit_ut;

  uvm_pkg::uvm_reg_map le_map, be_map, non_byte_map;


  function void build();
    svunit_ut = new(name);
    le_map = new("le_map");
    le_map.configure(null, 32'h0, 4, uvm_pkg::UVM_LITTLE_ENDIAN);
    le_map.Xinit_address_mapX();

    be_map = new("be_map");
    be_map.configure(null, 32'h0, 4, uvm_pkg::UVM_BIG_ENDIAN);
    be_map.Xinit_address_mapX();

    non_byte_map = new("non_byte_map");
    non_byte_map.configure(null, 32'h0, 4, uvm_pkg::UVM_LITTLE_ENDIAN, 0);
    non_byte_map.Xinit_address_mapX();
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_physical_addresses__access_one_byte_at_base_addr)
      uvm_pkg::uvm_reg_addr_t addr[];
      le_map.get_physical_addresses(32'h0, 32'h0, 1, addr);
      `FAIL_IF(addr != '{ 32'h0 })
    `SVTEST_END


    `SVTEST(get_physical_addresses__access_one_byte_at_offset)
      uvm_pkg::uvm_reg_addr_t addr[];
      le_map.get_physical_addresses(32'h0, 32'h10, 1, addr);
      `FAIL_IF(addr != '{ 32'h10 })
    `SVTEST_END


    `SVTEST(get_physical_addresses__access_one_byte_at_non_zero_base_addr)
      uvm_pkg::uvm_reg_addr_t addr[];
      le_map.get_physical_addresses(32'h10, 32'h0, 1, addr);
      `FAIL_IF(addr != '{ 32'h10 })
    `SVTEST_END


    `SVTEST(get_physical_addresses__access_one_byte_at_non_zero_base_addr_plus_offset)
      uvm_pkg::uvm_reg_addr_t addr[];
      le_map.get_physical_addresses(32'h10, 32'h10, 1, addr);
      `FAIL_IF(addr != '{ 32'h20 })
    `SVTEST_END


    //--------------------------------------------------------------------------
    // Access more bytes than the bus
    //--------------------------------------------------------------------------

    `SVTEST(get_physical_addresses__access_wide_at_base_addr_little_endian)
      uvm_pkg::uvm_reg_addr_t addr[];
      le_map.get_physical_addresses(32'h0, 32'h0, 8, addr);
      `FAIL_IF(addr != '{ 32'h0, 32'h4 })
    `SVTEST_END


    `SVTEST(get_physical_addresses__access_wide_at_base_addr_big_endian)
      uvm_pkg::uvm_reg_addr_t addr[];
      be_map.get_physical_addresses(32'h0, 32'h0, 8, addr);
      `FAIL_IF(addr != '{ 32'h4, 32'h0 })
    `SVTEST_END


    `SVTEST(get_physical_addresses__access_wide_at_offset_little_endian)
      uvm_pkg::uvm_reg_addr_t addr[];
      le_map.get_physical_addresses(32'h0, 32'h10, 8, addr);
      `FAIL_IF(addr != '{ 32'h10, 32'h14 })
    `SVTEST_END


    `SVTEST(get_physical_addresses__access_wide_at_offset_big_endian)
      uvm_pkg::uvm_reg_addr_t addr[];
      be_map.get_physical_addresses(32'h0, 32'h10, 8, addr);
      `FAIL_IF(addr != '{ 32'h14, 32'h10 })
    `SVTEST_END


    `SVTEST(get_physical_addresses__access_wide_at_base_addr_non_byte_addressed)
      uvm_pkg::uvm_reg_addr_t addr[];
      non_byte_map.get_physical_addresses(32'h0, 32'h0, 8, addr);
      `FAIL_IF(addr != '{ 32'h0, 32'h1 })
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
