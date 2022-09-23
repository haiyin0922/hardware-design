vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv \
"D:/XILINX/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/XILINX/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
"../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/src/Ps2Interface.v" \
"../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/src/KeyboardCtrl.v" \
"../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/sim/KeyboardCtrl_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

