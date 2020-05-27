# Read Design
read_file -format verilog Temp.v

current_design alu
uniquify
link

source -echo -verbose ./HW3_alu.sdc

############in sdc file
# Set the Optimization Constraints 

#############in sdc file


check_design

# remove_attribute [find -hierarchy design {"*"}] dont_touch

# Map and Optimize the Design
compile -map_effort medium

# Analyze and debug the design
report_area > area_alu.out
report_power > power_alu.out
report_timing -path full -delay max > timing_alu.out

#write -format db -hierarchy -output $active_design.db
write -format verilog -hierarchy -output HW3_alu_syn.v
write_sdf -version 2.1 -context verilog HW3_alu.sdf
write_sdc HW3_alu_syn.sdc
