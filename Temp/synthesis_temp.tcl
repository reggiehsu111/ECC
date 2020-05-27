# Read Design
read_file -format verilog Temp.v

current_design Top_ting
uniquify
link

source -echo -verbose ./top.sdc

############in sdc file
# Set the Optimization Constraints 

#############in sdc file


check_design

# remove_attribute [find -hierarchy design {"*"}] dont_touch

# Map and Optimize the Design
compile -map_effort medium

# Analyze and debug the design
report_area > area_top.out
report_power > power_top.out
report_timing -path full -delay max > timing_top.out

#write -format db -hierarchy -output $active_design.db
write -format verilog -hierarchy -output top_syn.v
write_sdf -version 2.1 -context verilog top_alu.sdf
write_sdc top_syn.sdc
