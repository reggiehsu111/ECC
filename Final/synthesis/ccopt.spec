###############################################################
#  Generated by:      Cadence Innovus 17.11-s080_1
#  OS:                Linux x86_64(Host ID cad29)
#  Generated on:      Tue Jun 30 14:35:42 2020
#  Design:            CHIP
#  Command:           create_ccopt_clock_tree_spec -file ./ccopt.spec
###############################################################
#-------------------------------------------------------------------------------
# Clock tree setup script - dialect: Innovus
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

namespace eval ::ccopt {}
namespace eval ::ccopt::ilm {}
set ::ccopt::ilm::ccoptSpecRestoreData {}
# Start by checking for unflattened ILMs.
# Will flatten if so and then check the db sync.
if { [catch {ccopt_check_and_flatten_ilms_no_restore}] } {
  return -code error
}
# cache the value of the restore command output by the ILM flattening code
set ::ccopt::ilm::ccoptSpecRestoreData $::ccopt::ilm::ccoptRestoreILMState

# Input pins determined constant across all timing configs.
set_ccopt_property case_analysis -pin ipad_i_clk/PD 0
set_ccopt_property case_analysis -pin ipad_i_clk/PU 0
set_ccopt_property case_analysis -pin ipad_i_clk/SMT 0

# Clocks present at pin i_clk
#   i_clk (period 10.000ns) in timing_config func_mode([design/CHIP.sdc])
#   i_clk (period 10.000ns) in timing_config scan_mode([design/CHIP.sdc])
create_ccopt_clock_tree -name i_clk -source i_clk -no_skew_group

# Clock period setting for source pin of i_clk
set_ccopt_property clock_period -pin i_clk 10

# Skew group to balance non generated clock:i_clk in timing_config:func_mode (sdc design/CHIP.sdc)
create_ccopt_skew_group -name i_clk/func_mode -sources i_clk -auto_sinks
set_ccopt_property include_source_latency -skew_group i_clk/func_mode true
set_ccopt_property target_insertion_delay -skew_group i_clk/func_mode 0.500
set_ccopt_property extracted_from_clock_name -skew_group i_clk/func_mode i_clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group i_clk/func_mode func_mode
set_ccopt_property extracted_from_delay_corners -skew_group i_clk/func_mode {DC_max DC_min}

# Skew group to balance non generated clock:i_clk in timing_config:scan_mode (sdc design/CHIP.sdc)
create_ccopt_skew_group -name i_clk/scan_mode -sources i_clk -auto_sinks
set_ccopt_property include_source_latency -skew_group i_clk/scan_mode true
set_ccopt_property target_insertion_delay -skew_group i_clk/scan_mode 0.500
set_ccopt_property extracted_from_clock_name -skew_group i_clk/scan_mode i_clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group i_clk/scan_mode scan_mode
set_ccopt_property extracted_from_delay_corners -skew_group i_clk/scan_mode {DC_max DC_min}


check_ccopt_clock_tree_convergence
# Restore the ILM status if possible
if { [get_ccopt_property auto_design_state_for_ilms] == 0 } {
  if {$::ccopt::ilm::ccoptSpecRestoreData != {} } {
    eval $::ccopt::ilm::ccoptSpecRestoreData
  }
}
