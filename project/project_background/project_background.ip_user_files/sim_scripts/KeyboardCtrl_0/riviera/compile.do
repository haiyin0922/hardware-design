vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"D:/XILINX/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/XILINX/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/src/Ps2Interface.v" \
"../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/src/KeyboardCtrl.v" \
"../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/sim/KeyboardCtrl_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

