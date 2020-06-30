set_clock_latency 0.5  [get_clocks {i_clk}]
set_clock_latency -source -early -min -rise  -0.247835 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -early -min -fall  -0.141987 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -late -min -rise  -0.247835 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -late -min -fall  -0.141987 [get_ports {i_clk}] -clock i_clk 
