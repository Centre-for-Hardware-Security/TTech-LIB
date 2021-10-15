#created by TMlib
set_db information_level 99
set_db syn_global_effort high
set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high
set_db retime_verification_flow false
set LIB {/export/designkits/tsmc/tsmc65/ip/msrflp/STDCELL/tcbn65lphvt_220a/FE/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lphvt_220a/tcbn65lphvttc.lib}
set SOURCE_PATH {../../vlog/schoolbook/}
set FILE_LIST {schoolbook.192x192.pip3.v}
set_db init_hdl_search_path "$SOURCE_PATH"
set TOP MUL
read_libs ${LIB}
read_hdl "$FILE_LIST"
time_info
elaborate
write_hdl -generic > schoolbook.192x192.pip3.generic.v
time_info
check_design -unresolved
set_time_unit -nanoseconds
set CLK_PORT_NAME clk
create_clock -name "fast" -period 1.22 $CLK_PORT_NAME
set_input_delay -clock fast 0.001 [all_inputs]
set_dont_use SDF*
set_dont_use SED*
set_dont_use DEL*
set_dont_use CK*
set_dont_use LH*
set_dont_use LN*
set_dont_use *DCAP*
retime -prepare
time_info
retime -min_delay
time_info
syn_generic
time_info
syn_map
time_info
syn_opt
time_info
write_hdl > schoolbook.192x192.pip3.mapped.v
report_area > schoolbook.192x192.pip3.area.rpt
report_power > schoolbook.192x192.pip3.power.rpt
report_timing > schoolbook.192x192.pip3.timing.rpt
report_gates > schoolbook.192x192.pip3.gates.rpt
report_runtime > schoolbook.192x192.pip3.runtime.rpt
