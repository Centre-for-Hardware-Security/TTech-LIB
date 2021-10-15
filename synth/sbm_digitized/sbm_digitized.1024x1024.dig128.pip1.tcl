#created by TMlib
set_db information_level 99
set_db syn_global_effort high
set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high
set_db retime_verification_flow false
set LIB {/cad/env_15nm/NanGate_15nm_OCL/front_end/timing_power_noise/NLDM/NanGate_15nm_OCL_typical_conditional_nldm.lib}
set SOURCE_PATH {../../vlog/sbm_digitized/}
set FILE_LIST {sbm_digitized.1024x1024.dig128.pip1.v}
set_db init_hdl_search_path "$SOURCE_PATH"
set TOP MUL
read_libs ${LIB}
read_hdl "$FILE_LIST"
time_info
elaborate
write_hdl -generic > sbm_digitized.1024x1024.dig128.pip1.generic.v
time_info
check_design -unresolved
set_time_unit -nanoseconds
set CLK_PORT_NAME clk
create_clock -name "fast" -period 1 $CLK_PORT_NAME
set_input_delay -clock fast 0.001 [all_inputs]
#set_dont_use SDF*
#set_dont_use SED*
#set_dont_use DEL*
#set_dont_use CK*
#set_dont_use LH*
#set_dont_use LN*
#set_dont_use *DCAP*
syn_generic
time_info
syn_map
time_info
syn_opt
time_info
write_hdl > sbm_digitized.1024x1024.dig128.pip1.mapped.v
report_area > sbm_digitized.1024x1024.dig128.pip1.area.rpt
report_power > sbm_digitized.1024x1024.dig128.pip1.power.rpt
report_timing > sbm_digitized.1024x1024.dig128.pip1.timing.rpt
report_gates > sbm_digitized.1024x1024.dig128.pip1.gates.rpt
report_runtime > sbm_digitized.1024x1024.dig128.pip1.runtime.rpt
