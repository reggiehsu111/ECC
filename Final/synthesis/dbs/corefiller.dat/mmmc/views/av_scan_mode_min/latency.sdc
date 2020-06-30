set_clock_latency 0.5  [get_clocks {i_clk}]
set_clock_latency -source -early -min -rise  -0.254607 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -early -min -fall  -0.147422 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -late -min -rise  -0.254607 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -late -min -fall  -0.147422 [get_ports {i_clk}] -clock i_clk 
