# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]	
	
#7 segment display
#set_property PACKAGE_PIN W7 [get_ports {display[0]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {display[0]}]
#set_property PACKAGE_PIN W6 [get_ports {display[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {display[1]}]
#set_property PACKAGE_PIN U8 [get_ports {display[2]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {display[2]}]
#set_property PACKAGE_PIN V8 [get_ports {display[3]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {display[3]}]
#set_property PACKAGE_PIN U5 [get_ports {display[4]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {display[4]}]
#set_property PACKAGE_PIN V5 [get_ports {display[5]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {display[5]}]
#set_property PACKAGE_PIN U7 [get_ports {display[6]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {display[6]}]

#set_property PACKAGE_PIN V7 [get_ports dp]							
	#set_property IOSTANDARD LVCMOS33 [get_ports dp]

#set_property PACKAGE_PIN U2 [get_ports {digit[0]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {digit[0]}]
#set_property PACKAGE_PIN U4 [get_ports {digit[1]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {digit[1]}]
#set_property PACKAGE_PIN V4 [get_ports {digit[2]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {digit[2]}]
#set_property PACKAGE_PIN W4 [get_ports {digit[3]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {digit[3]}]


#Buttons
#set_property PACKAGE_PIN U18 [get_ports rst]						
#	set_property IOSTANDARD LVCMOS33 [get_ports rst]
 
#USB HID (PS/2)
set_property PACKAGE_PIN C17 [get_ports PS2_CLK]						
	set_property IOSTANDARD LVCMOS33 [get_ports PS2_CLK]
	set_property PULLUP true [get_ports PS2_CLK]
set_property PACKAGE_PIN B17 [get_ports PS2_DATA]					
	set_property IOSTANDARD LVCMOS33 [get_ports PS2_DATA]	
	set_property PULLUP true [get_ports PS2_DATA]
	
    
##Pmod Header JC
    #Sch name = JC1
        set_property PACKAGE_PIN K17 [get_ports {button_UP}]
        set_property IOSTANDARD LVCMOS33 [get_ports {button_UP}]
    ##Sch name = JC2
        set_property PACKAGE_PIN M18 [get_ports {button_DOWN}]
        set_property IOSTANDARD LVCMOS33 [get_ports {button_DOWN}]
    ##Sch name = JC3
        set_property PACKAGE_PIN N17 [get_ports {button_LEFT}]
        set_property IOSTANDARD LVCMOS33 [get_ports {button_LEFT}]
    ##Sch name = JC4
        set_property PACKAGE_PIN P18 [get_ports {button_RIGHT}]
        set_property IOSTANDARD LVCMOS33 [get_ports {button_RIGHT}]
    ##Sch name = JC7
        set_property PACKAGE_PIN L17 [get_ports {button_ATTACK}]
        set_property IOSTANDARD LVCMOS33 [get_ports {button_ATTACK}]
    ##Sch name = JC8
        #set_property PACKAGE_PIN M19 [get_ports {JC[5]}]
        #set_property IOSTANDARD LVCMOS33 [get_ports {JC[5]}]
    ##Sch name = JC9
    #set_property PACKAGE_PIN P17 [get_ports {JC[6]}]
    #set_property IOSTANDARD LVCMOS33 [get_ports {JC[6]}]
    ##Sch name = JC10
    #set_property PACKAGE_PIN R18 [get_ports {JC[7]}]
    #set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]

