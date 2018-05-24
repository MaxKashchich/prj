derive_pll_clocks
derive_clock_uncertainty


create_clock -name {clk} -period 10.0 -waveform { 0.000 5.0 } [get_ports { clk }]
create_clock -name {pcie_refclk_p} -period 10.0 -waveform { 0.000 5.0 } [get_ports { pcie_refclk_p }]
create_clock -name {CLK_125_P} -period 8.000 -waveform {0 4.0} {CLK_125_P}


create_clock -name {altera_reserved_tck} -period 41.667 [get_ports { altera_reserved_tck }]
set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall -max 5 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 5 [get_ports altera_reserved_tdo]



set_false_path -from [get_ports {pcie_perstn}]
set_false_path -from [get_ports {cpu_resetn}]
set_false_path -to [get_ports {user_led[*]}]

