-- See the file "LICENSE" for the full license governing this code. --

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.lt16x32_internal.all;
use work.lt16x32_global.all;
use work.wishbone.all;
use work.config.all;

package lt16soc_peripherals is

	component wb_led is
	generic(
		memaddr		:	generic_addr_type;-- := CFG_BADR_LED;
		addrmask	:	generic_mask_type-- := CFG_MADR_LED;
	);
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		led		: out  std_logic_vector(7 downto 0);
		wslvi	:	in	wb_slv_in_type;
		wslvo	:	out	wb_slv_out_type
	);
	end component;
	
	component swbtn is
	generic(
		memaddr		:	generic_addr_type;-- := CFG_BADR_SWBTN;
		addrmask	:	generic_mask_type-- := CFG_MADR_SWBTN;
	);
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		--led		: out std_logic_vector(7 downto 0);
		btn		: in  std_logic_vector(4 downto 0);
		sw		: in  std_logic_vector(7 downto 0);
		switchint      : out std_logic;
		wslvi	: in   wb_slv_in_type;
		wslvo	: out	wb_slv_out_type
		
	);
	end component;
	
--	component counter is
--	generic(
--		memaddr		:	generic_addr_type;-- := CFG_BADR_ISRCNT;
--		addrmask	:	generic_mask_type-- := CFG_MADR_ISRCNT;
--	);
--	port(
--		clk		: in  std_logic;
--		rst		: in  std_logic;
		--led		: out  std_logic_vector(7 downto 0);
--		isr		: out std_logic ;
--		wslvi	:	in	wb_slv_in_type;
--		wslvo	:	out	wb_slv_out_type
	
--	);
--	end component;
	
component led_top is
	generic(
		memaddr		:	generic_addr_type;-- := CFG_BADR_LEDTOP;
		addrmask	:	generic_mask_type --:= CFG_MADR_LEDTOP
	);
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		led		: out  std_logic_vector(7 downto 0);
		wslvi	:	in	wb_slv_in_type;
		wslvo	:	out	wb_slv_out_type
	);
end component;

component can_vhdl_top is
        generic(
	 	memaddr		: generic_addr_type;
		addrmask	: generic_mask_type
	);
	port(
	clk 		: in std_logic;
	rstn 		: in std_logic;
	wbs_i 		: in wb_slv_in_type;
	wbs_o 		: out wb_slv_out_type;
	rx_i 		: in std_logic;
	tx_o 		: out std_logic;
	driver_en	: out std_logic;
	irq_on 	: out std_logic
	
	);
end component;

end lt16soc_peripherals;

package body lt16soc_peripherals is

	--insert function bodies

end lt16soc_peripherals;


