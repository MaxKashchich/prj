onerror {exit -code 1}
vlib work
vlog -work work c5gt_gen2x4_mSGMDA.vo
vlog -work work Waveform_math.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.math_vlg_vec_tst -voptargs="+acc"
vcd file -direction math.msim.vcd
vcd add -internal math_vlg_vec_tst/*
vcd add -internal math_vlg_vec_tst/i1/*
run -all
quit -f
