#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Jun 25 08:37:43 2020                
#                                                     
#######################################################

#@(#)CDS: Innovus v17.11-s080_1 (64bit) 08/04/2017 11:13 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 17.11-s080_1 NR170721-2155/17_11-UB (database version 2.30, 390.7.1) {superthreading v1.44}
#@(#)CDS: AAE 17.11-s034 (64bit) 08/04/2017 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 17.11-s053_1 () Aug  1 2017 23:31:41 ( )
#@(#)CDS: SYNTECH 17.11-s012_1 () Jul 21 2017 02:29:12 ( )
#@(#)CDS: CPE v17.11-s095
#@(#)CDS: IQRC/TQRC 16.1.1-s215 (64bit) Thu Jul  6 20:18:10 PDT 2017 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
save_global Default.globals
set init_gnd_net GND
set init_lef_file {lef/header6_V55_20ka_cic.lef lef/fsa0m_a_generic_core.lef lef/FSA0M_A_GENERIC_CORE_ANT_V55.lef lef/fsa0m_a_t33_generic_io.lef lef/FSA0M_A_T33_GENERIC_IO_ANT_V55.lef lef/BONDPAD.lef}
set init_verilog design/CHIP_syn.v
set init_mmmc_file mmmc.view
set init_io_file design/CHIP.ioc
set init_top_cell CHIP
set init_pwr_net VCC
init_design
set init_gnd_net GND
set init_lef_file {lef/header6_V55_20ka_cic.lef lef/fsa0m_a_generic_core.lef lef/FSA0M_A_GENERIC_CORE_ANT_V55.lef lef/fsa0m_a_t33_generic_io.lef lef/FSA0M_A_T33_GENERIC_IO_ANT_V55.lef lef/BONDPAD.lef}
set init_verilog design/CHIP_syn.v
set init_mmmc_file mmmc.view
set init_io_file design/CHIP.ioc
set init_top_cell CHIP
set init_pwr_net VCC
init_design
set init_gnd_net GND
set init_lef_file {lef/header6_V55_20ka_cic.lef lef/fsa0m_a_generic_core.lef lef/FSA0M_A_GENERIC_CORE_ANT_V55.lef lef/fsa0m_a_t33_generic_io.lef lef/FSA0M_A_T33_GENERIC_IO_ANT_V55.lef lef/BONDPAD.lef}
set init_verilog design/CHIP_syn.v
set init_mmmc_file mmmc.view
set init_io_file design/CHIP.ioc
set init_top_cell CHIP
set init_pwr_net VCC
init_design
set init_gnd_net GND
set init_lef_file {lef/header6_V55_20ka_cic.lef lef/fsa0m_a_generic_core.lef lef/FSA0M_A_GENERIC_CORE_ANT_V55.lef lef/fsa0m_a_t33_generic_io.lef lef/FSA0M_A_T33_GENERIC_IO_ANT_V55.lef lef/BONDPAD.lef}
set init_verilog design/CHIP_syn.v
set init_mmmc_file mmmc.view
set init_io_file design/CHIP.ioc
set init_top_cell CHIP
set init_pwr_net VCC
init_design
clearGlobalNets
globalNetConnect VCC -type pgpin -pin VCC -inst *
globalNetConnect GND -type pgpin -pin GND -inst *
getIoFlowFlag
setIoFlowFlag 0
floorPlan -site core_5040 -d 1500 1500 80 80 80 80
uiSetTool select
getIoFlowFlag
fit
setIoFlowFlag 0
floorPlan -site core_5040 -d 1499.78 1500.24 79.98 80.08 79.98 80.08
uiSetTool select
getIoFlowFlag
fit
setDrawView fplan
setDrawView place
setDrawView place
setDrawView place
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer metal6 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VCC GND} -type core_rings -follow core -layer {top metal5 bottom metal5 left metal4 right metal4} -width {top 2 bottom 2 left 2 right 2} -spacing {top 0.28 bottom 0.28 left 0.28 right 0.28} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -extend_corner {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None -use_wire_group 1 -use_wire_group_bits 15 -use_interleaving_wire_group 1
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer metal6 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VCC GND} -type core_rings -follow core -layer {top metal5 bottom metal5 left metal4 right metal4} -width {top 2 bottom 2 left 2 right 2} -spacing {top 0.28 bottom 0.28 left 0.28 right 0.28} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -extend_corner {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None -use_wire_group 1 -use_wire_group_bits 15 -use_interleaving_wire_group 1
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { padPin } -layerChangeRange { metal1(1) metal6(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -allowJogging 1 -crossoverViaLayerRange { metal1(1) metal6(6) } -nets { VCC GND } -allowLayerChange 1 -targetViaLayerRange { metal1(1) metal6(6) }
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -mergedMGridCheck true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000
verifyGeometry
setVerifyGeometryMode -area { 0 0 0 0 }
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length 0 -stacked_via_top_layer metal6 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring }
addStripe -nets {VCC GND} -layer metal4 -direction vertical -width 1 -spacing 0.28 -set_to_set_distance 50 -start_from left -start_offset 20 -stop_offset 20 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit metal6 -padcore_ring_bottom_layer_limit metal1 -block_ring_top_layer_limit metal6 -block_ring_bottom_layer_limit metal1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
saveDesign dbs/powerplan
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -mergedMGridCheck true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000
verifyGeometry
setVerifyGeometryMode -area { 0 0 0 0 }
setLayerPreference violation -isVisible 1
violationBrowser -all -no_display_false
violationBrowserClose
setSrouteMode -viaConnectToShape { ring }
sroute -connect { corePin } -layerChangeRange { metal1(1) metal6(6) } -blockPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -allowJogging 1 -crossoverViaLayerRange { metal1(1) metal6(6) } -nets { VCC GND } -allowLayerChange 1 -targetViaLayerRange { metal1(1) metal6(6) }
