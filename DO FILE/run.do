vlog top.sv

vsim top +testname=test_5_wr_5_rd

add wave -position insertpoint sim:/top/pif/*

run -all
