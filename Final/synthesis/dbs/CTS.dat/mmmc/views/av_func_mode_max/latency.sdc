set_clock_latency 0.5  [get_clocks {i_clk}]
set_clock_latency -source -early -max -rise  -1.03293 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -early -max -fall  -0.786686 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -late -max -rise  -1.03293 [get_ports {i_clk}] -clock i_clk 
set_clock_latency -source -late -max -fall  -0.786686 [get_ports {i_clk}] -clock i_clk 
