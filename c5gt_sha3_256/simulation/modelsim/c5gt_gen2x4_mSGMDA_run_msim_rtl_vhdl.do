transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/mkashchych/Downloads/c5gt_sha3_256/math.vhd}
vcom -93 -work work {C:/Users/mkashchych/Downloads/c5gt_sha3_256/test_top.vhd}

vcom -93 -work work {C:/Users/mkashchych/Downloads/c5gt_sha3_256/math_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  math_tb

add wave *
view structure
view signals
run -all
