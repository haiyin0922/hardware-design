
{
Command: %s
53*	vivadotcl2J
6synth_design -top player2control -part xc7a35tcpg236-12default:defaultZ4-113h px? 
:
Starting synth_design
149*	vivadotclZ4-321h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7a35t2default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7a35t2default:defaultZ17-349h px? 
?
%s*synth2?
wStarting RTL Elaboration : Time (s): cpu = 00:00:02 ; elapsed = 00:00:02 . Memory (MB): peak = 384.621 ; gain = 97.066
2default:defaulth px? 
?
synthesizing module '%s'%s4497*oasys2"
player2control2default:default2
 2default:default2Z
DC:/player2control/player2control.srcs/sources_1/new/player2control.v2default:default2
12default:default8@Z8-6157h px? 
Y
%s
*synth2A
-	Parameter KEYCODE_W bound to: 9'b000011101 
2default:defaulth p
x
? 
Y
%s
*synth2A
-	Parameter KEYCODE_S bound to: 9'b000011011 
2default:defaulth p
x
? 
Y
%s
*synth2A
-	Parameter KEYCODE_A bound to: 9'b000011100 
2default:defaulth p
x
? 
Y
%s
*synth2A
-	Parameter KEYCODE_D bound to: 9'b000100011 
2default:defaulth p
x
? 
Y
%s
*synth2A
-	Parameter KEYCODE_G bound to: 9'b000110100 
2default:defaulth p
x
? 
?
synthesizing module '%s'%s4497*oasys2#
KeyboardDecoder2default:default2
 2default:default2r
\C:/player2control/player2control.srcs/sources_1/imports/KeyboardSampleCode/KeyboardDecoder.v2default:default2
12default:default8@Z8-6157h px? 
M
%s
*synth25
!	Parameter INIT bound to: 2'b00 
2default:defaulth p
x
? 
X
%s
*synth2@
,	Parameter WAIT_FOR_SIGNAL bound to: 2'b01 
2default:defaulth p
x
? 
X
%s
*synth2@
,	Parameter GET_SIGNAL_DOWN bound to: 2'b10 
2default:defaulth p
x
? 
U
%s
*synth2=
)	Parameter WAIT_RELEASE bound to: 2'b11 
2default:defaulth p
x
? 
V
%s
*synth2>
*	Parameter IS_INIT bound to: 8'b10101010 
2default:defaulth p
x
? 
X
%s
*synth2@
,	Parameter IS_EXTEND bound to: 8'b11100000 
2default:defaulth p
x
? 
W
%s
*synth2?
+	Parameter IS_BREAK bound to: 8'b11110000 
2default:defaulth p
x
? 
?
synthesizing module '%s'%s4497*oasys2"
KeyboardCtrl_02default:default2
 2default:default2?
mC:/player2control/player2control.runs/synth_1/.Xil/Vivado-1364-DESKTOP-TG1464E/realtime/KeyboardCtrl_0_stub.v2default:default2
62default:default8@Z8-6157h px? 
?
'done synthesizing module '%s'%s (%s#%s)4495*oasys2"
KeyboardCtrl_02default:default2
 2default:default2
12default:default2
12default:default2?
mC:/player2control/player2control.runs/synth_1/.Xil/Vivado-1364-DESKTOP-TG1464E/realtime/KeyboardCtrl_0_stub.v2default:default2
62default:default8@Z8-6155h px? 
?
synthesizing module '%s'%s4497*oasys2
OnePulse2default:default2
 2default:default2k
UC:/player2control/player2control.srcs/sources_1/imports/KeyboardSampleCode/OnePulse.v2default:default2
12default:default8@Z8-6157h px? 
?
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
OnePulse2default:default2
 2default:default2
22default:default2
12default:default2k
UC:/player2control/player2control.srcs/sources_1/imports/KeyboardSampleCode/OnePulse.v2default:default2
12default:default8@Z8-6155h px? 
?
default block is never used226*oasys2r
\C:/player2control/player2control.srcs/sources_1/imports/KeyboardSampleCode/KeyboardDecoder.v2default:default2
642default:default8@Z8-226h px? 
?
'done synthesizing module '%s'%s (%s#%s)4495*oasys2#
KeyboardDecoder2default:default2
 2default:default2
32default:default2
12default:default2r
\C:/player2control/player2control.srcs/sources_1/imports/KeyboardSampleCode/KeyboardDecoder.v2default:default2
12default:default8@Z8-6155h px? 
?
0Net %s in module/entity %s does not have driver.3422*oasys2
rst2default:default2"
player2control2default:default2Z
DC:/player2control/player2control.srcs/sources_1/new/player2control.v2default:default2
312default:default8@Z8-3848h px? 
?
'done synthesizing module '%s'%s (%s#%s)4495*oasys2"
player2control2default:default2
 2default:default2
42default:default2
12default:default2Z
DC:/player2control/player2control.srcs/sources_1/new/player2control.v2default:default2
12default:default8@Z8-6155h px? 
?
%s*synth2?
xFinished RTL Elaboration : Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 439.031 ; gain = 151.477
2default:defaulth px? 
D
%s
*synth2,

Report Check Netlist: 
2default:defaulth p
x
? 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
? 
u
%s
*synth2]
I|      |Item              |Errors |Warnings |Status |Description       |
2default:defaulth p
x
? 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
? 
u
%s
*synth2]
I|1     |multi_driven_nets |      0|        0|Passed |Multi driven nets |
2default:defaulth p
x
? 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
? 
?
'tying undriven pin %s:%s to constant 0
3295*oasys2
key_de2default:default2
rst2default:default2Z
DC:/player2control/player2control.srcs/sources_1/new/player2control.v2default:default2
252default:default8@Z8-3295h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Handling Custom Attributes : Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 439.031 ; gain = 151.477
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 439.031 ; gain = 151.477
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
V
Loading part %s157*device2#
xc7a35tcpg236-12default:defaultZ21-403h px? 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px? 
>

Processing XDC Constraints
244*projectZ1-262h px? 
=
Initializing timing engine
348*projectZ1-569h px? 
?
$Parsing XDC File [%s] for cell '%s'
848*designutils2?
nc:/player2control/player2control.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0/KeyboardCtrl_0_in_context.xdc2default:default2!
key_de/inst	2default:default8Z20-848h px? 
?
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2?
nc:/player2control/player2control.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0/KeyboardCtrl_0_in_context.xdc2default:default2!
key_de/inst	2default:default8Z20-847h px? 
?
Parsing XDC File [%s]
179*designutils2x
bC:/player2control/player2control.srcs/constrs_1/imports/KeyboardSampleCode/KeyboardConstraints.xdc2default:default8Z20-179h px? 
?
Finished Parsing XDC File [%s]
178*designutils2x
bC:/player2control/player2control.srcs/constrs_1/imports/KeyboardSampleCode/KeyboardConstraints.xdc2default:default8Z20-178h px? 
?
?Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2v
bC:/player2control/player2control.srcs/constrs_1/imports/KeyboardSampleCode/KeyboardConstraints.xdc2default:default24
 .Xil/player2control_propImpl.xdc2default:defaultZ1-236h px? 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px? 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common24
 Constraint Validation Runtime : 2default:default2
00:00:002default:default2 
00:00:00.0062default:default2
750.9262default:default2
0.0002default:defaultZ17-268h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
~Finished Constraint Validation : Time (s): cpu = 00:00:11 ; elapsed = 00:00:13 . Memory (MB): peak = 750.926 ; gain = 463.371
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
J
%s
*synth22
Loading part: xc7a35tcpg236-1
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Loading Part and Timing Information : Time (s): cpu = 00:00:11 ; elapsed = 00:00:13 . Memory (MB): peak = 750.926 ; gain = 463.371
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
Z
%s
*synth2B
.Start Applying 'set_property' XDC Constraints
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:11 ; elapsed = 00:00:13 . Memory (MB): peak = 750.926 ; gain = 463.371
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2default:default2#
KeyboardDecoder2default:defaultZ8-802h px? 
u
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
state2default:defaultZ8-5546h px? 
u
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
state2default:defaultZ8-5546h px? 
u
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
state2default:defaultZ8-5546h px? 
?
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
state2default:default2
12default:default2
52default:defaultZ8-5544h px? 
?
[ROM "%s" won't be mapped to Block RAM because address size (%s) smaller than threshold (%s)3996*oasys2
state2default:default2
12default:default2
52default:defaultZ8-5544h px? 
?
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2t
`                   State |                     New Encoding |                Previous Encoding 
2default:defaulth p
x
? 
?
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2s
_                    INIT |                               00 |                               00
2default:defaulth p
x
? 
?
%s
*synth2s
_         WAIT_FOR_SIGNAL |                               01 |                               01
2default:defaulth p
x
? 
?
%s
*synth2s
_         GET_SIGNAL_DOWN |                               10 |                               10
2default:defaulth p
x
? 
?
%s
*synth2s
_            WAIT_RELEASE |                               11 |                               11
2default:defaulth p
x
? 
?
%s
*synth2x
d---------------------------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2default:default2

sequential2default:default2#
KeyboardDecoder2default:defaultZ8-3354h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:12 ; elapsed = 00:00:13 . Memory (MB): peak = 750.926 ; gain = 463.371
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
? 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	              512 Bit    Registers := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	               10 Bit    Registers := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	                1 Bit    Registers := 6     
2default:defaulth p
x
? 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   2 Input    512 Bit        Muxes := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   4 Input     10 Bit        Muxes := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   4 Input      2 Bit        Muxes := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   2 Input      2 Bit        Muxes := 3     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   2 Input      1 Bit        Muxes := 8     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   4 Input      1 Bit        Muxes := 7     
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
Y
%s
*synth2A
-Start RTL Hierarchical Component Statistics 
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
O
%s
*synth27
#Hierarchical RTL Component report 
2default:defaulth p
x
? 
=
%s
*synth2%
Module OnePulse 
2default:defaulth p
x
? 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
? 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	                1 Bit    Registers := 2     
2default:defaulth p
x
? 
D
%s
*synth2,
Module KeyboardDecoder 
2default:defaulth p
x
? 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
? 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	              512 Bit    Registers := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	               10 Bit    Registers := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	                1 Bit    Registers := 4     
2default:defaulth p
x
? 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   2 Input    512 Bit        Muxes := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   4 Input     10 Bit        Muxes := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   4 Input      2 Bit        Muxes := 1     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   2 Input      2 Bit        Muxes := 3     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   2 Input      1 Bit        Muxes := 8     
2default:defaulth p
x
? 
Z
%s
*synth2B
.	   4 Input      1 Bit        Muxes := 7     
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
[
%s
*synth2C
/Finished RTL Hierarchical Component Statistics
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2j
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
]
%s
*synth2E
1Warning: Parallel synthesis criteria is not met 
2default:defaulth p
x
? 
u
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2
state2default:defaultZ8-5546h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[511]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[510]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[509]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[508]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[507]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[506]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[505]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[504]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[503]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[502]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[501]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[500]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[499]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[498]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[497]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[496]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[495]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[494]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[493]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[492]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[491]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[490]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[489]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[488]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[487]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[486]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[485]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[484]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[483]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[482]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[481]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[480]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[479]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[478]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[477]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[476]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[475]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[474]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[473]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[472]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[471]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[470]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[469]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[468]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[467]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[466]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[465]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[464]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[463]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[462]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[461]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[460]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[459]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[458]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[457]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[456]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[455]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[454]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[453]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[452]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[451]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[450]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[449]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[448]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[447]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[446]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[445]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[444]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[443]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[442]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[441]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[440]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[439]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[438]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[437]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[436]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[435]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[434]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[433]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[432]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[431]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[430]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[429]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[428]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[427]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[426]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[425]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[424]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[423]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[422]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[421]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[420]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[419]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[418]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[417]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[416]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[415]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[414]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[413]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2,
key_de/key_down_reg[412]2default:default2"
player2control2default:defaultZ8-3332h px? 
?
?Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2 
Synth 8-33322default:default2
1002default:defaultZ17-14h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:13 ; elapsed = 00:00:14 . Memory (MB): peak = 750.926 ; gain = 463.371
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
R
%s
*synth2:
&Start Applying XDC Timing Constraints
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:20 ; elapsed = 00:00:23 . Memory (MB): peak = 766.930 ; gain = 479.375
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
|Finished Timing Optimization : Time (s): cpu = 00:00:20 ; elapsed = 00:00:23 . Memory (MB): peak = 786.285 ; gain = 498.730
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
6propagating constant %s across sequential element (%s)3333*oasys2
12default:default2*
\key_de/key_valid_reg 2default:defaultZ8-3333h px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
{Finished Technology Mapping : Time (s): cpu = 00:00:20 ; elapsed = 00:00:23 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
uFinished IO Insertion : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
D
%s
*synth2,

Report Check Netlist: 
2default:defaulth p
x
? 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
? 
u
%s
*synth2]
I|      |Item              |Errors |Warnings |Status |Description       |
2default:defaulth p
x
? 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
? 
u
%s
*synth2]
I|1     |multi_driven_nets |      0|        0|Passed |Multi driven nets |
2default:defaulth p
x
? 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Instances : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Ports : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Handling Custom Attributes : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Renaming Generated Nets : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
? 
P
%s
*synth28
$+------+---------------+----------+
2default:defaulth p
x
? 
P
%s
*synth28
$|      |BlackBox name  |Instances |
2default:defaulth p
x
? 
P
%s
*synth28
$+------+---------------+----------+
2default:defaulth p
x
? 
P
%s
*synth28
$|1     |KeyboardCtrl_0 |         1|
2default:defaulth p
x
? 
P
%s
*synth28
$+------+---------------+----------+
2default:defaulth p
x
? 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px? 
L
%s*synth24
 +------+---------------+------+
2default:defaulth px? 
L
%s*synth24
 |      |Cell           |Count |
2default:defaulth px? 
L
%s*synth24
 +------+---------------+------+
2default:defaulth px? 
L
%s*synth24
 |1     |KeyboardCtrl_0 |     1|
2default:defaulth px? 
L
%s*synth24
 |2     |BUFG           |     1|
2default:defaulth px? 
L
%s*synth24
 |3     |LUT2           |    11|
2default:defaulth px? 
L
%s*synth24
 |4     |LUT3           |     3|
2default:defaulth px? 
L
%s*synth24
 |5     |LUT4           |     3|
2default:defaulth px? 
L
%s*synth24
 |6     |LUT5           |     2|
2default:defaulth px? 
L
%s*synth24
 |7     |LUT6           |     9|
2default:defaulth px? 
L
%s*synth24
 |8     |FDRE           |    22|
2default:defaulth px? 
L
%s*synth24
 |9     |IBUF           |     1|
2default:defaulth px? 
L
%s*synth24
 |10    |OBUF           |     5|
2default:defaulth px? 
L
%s*synth24
 +------+---------------+------+
2default:defaulth px? 
E
%s
*synth2-

Report Instance Areas: 
2default:defaulth p
x
? 
W
%s
*synth2?
++------+---------+----------------+------+
2default:defaulth p
x
? 
W
%s
*synth2?
+|      |Instance |Module          |Cells |
2default:defaulth p
x
? 
W
%s
*synth2?
++------+---------+----------------+------+
2default:defaulth p
x
? 
W
%s
*synth2?
+|1     |top      |                |    69|
2default:defaulth p
x
? 
W
%s
*synth2?
+|2     |  key_de |KeyboardDecoder |    62|
2default:defaulth p
x
? 
W
%s
*synth2?
+|3     |    op   |OnePulse        |     3|
2default:defaulth p
x
? 
W
%s
*synth2?
++------+---------+----------------+------+
2default:defaulth p
x
? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
?
%s*synth2?
?Finished Writing Synthesis Report : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth px? 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
? 
t
%s
*synth2\
HSynthesis finished with 0 errors, 0 critical warnings and 508 warnings.
2default:defaulth p
x
? 
?
%s
*synth2?
~Synthesis Optimization Runtime : Time (s): cpu = 00:00:13 ; elapsed = 00:00:17 . Memory (MB): peak = 787.055 ; gain = 187.605
2default:defaulth p
x
? 
?
%s
*synth2?
Synthesis Optimization Complete : Time (s): cpu = 00:00:22 ; elapsed = 00:00:24 . Memory (MB): peak = 787.055 ; gain = 499.500
2default:defaulth p
x
? 
B
 Translating synthesized netlist
350*projectZ1-571h px? 
e
-Analyzing %s Unisim elements for replacement
17*netlist2
12default:defaultZ29-17h px? 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px? 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px? 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px? 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px? 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
312default:default2
1022default:default2
02default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
synth_design: 2default:default2
00:00:232default:default2
00:00:262default:default2
789.4962default:default2
513.4102default:defaultZ17-268h px? 
K
"No constraint will be written out.1103*constraintsZ18-5210h px? 
?
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2T
@C:/player2control/player2control.runs/synth_1/player2control.dcp2default:defaultZ17-1381h px? 
?
%s4*runtcl2?
rExecuting : report_utilization -file player2control_utilization_synth.rpt -pb player2control_utilization_synth.pb
2default:defaulth px? 
?
sreport_utilization: Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.027 . Memory (MB): peak = 789.496 ; gain = 0.000
*commonh px? 
?
Exiting %s at %s...
206*common2
Vivado2default:default2,
Thu Jan 10 03:46:02 20192default:defaultZ17-206h px? 


End Record