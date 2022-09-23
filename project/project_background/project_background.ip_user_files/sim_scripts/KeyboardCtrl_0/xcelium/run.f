-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/XILINX/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/XILINX/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/src/Ps2Interface.v" \
  "../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/src/KeyboardCtrl.v" \
  "../../../../project_background.srcs/sources_1/ip/KeyboardCtrl_0/sim/KeyboardCtrl_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

