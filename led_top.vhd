-- See the file "LICENSE" for the full license governing this code. --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.lt16x32_global.all;
use work.wishbone.all;
use work.config.all;

entity led_top is
	generic(
		memaddr		:	generic_addr_type; --:= CFG_BADR_LED;
		addrmask	:	generic_mask_type --:= CFG_MADR_LED;
	);
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		led		: out  std_logic_vector(7 downto 0);
		wslvi	:	in	wb_slv_in_type;
		wslvo	:	out	wb_slv_out_type
	);
end led_top;


architecture Behavioral of led_top is

	signal data : std_logic_vector(7 downto 0);
	signal ack	: std_logic;
	
	signal cnt_start : std_logic;
	signal cnt_done : std_logic;
	signal cnt_value : std_logic_vector(31 downto 0);
	
	signal buffer_clear 	: std_logic;
	--write parameters
	signal buffer_write 	: std_logic;
	signal buffer_data 	: std_logic_vector(7 downto 0);
	--read parameters
	signal next_pattern 	: std_logic;
	signal led_pattern 	: std_logic_vector(7 downto 0);
	signal on_off : std_logic;
	
	--led : out std_logic_vector(7 downto 0)

	signal ctrl_flgs	: std_logic_vector(31 downto 0):=(others=>'0');

	component led_timer
	port(
		clk       : in  std_logic;
		rst       : in  std_logic;

		cnt_start : in std_logic;
		cnt_done : out std_logic;
		cnt_value : in std_logic_vector(31 downto 0)
	);
	end component;

	component led_buffer
	generic(
			RAM_WIDTH	:	natural := 8;
			RAM_DEPTH	:	natural := 16
		);
		port(
		clk 			: in std_logic;
		rst 			: in std_logic;
		buffer_clear 	: in std_logic;
		--write parameters
		buffer_write 	: in std_logic;
		buffer_data 	: in std_logic_vector(7 downto 0);
		--read parameters
		next_pattern 	: in std_logic;
		led_pattern 	: out std_logic_vector(7 downto 0)

	);
	end component;

	component led_controller is
		port(
				clk : in std_logic;
				rst : in std_logic;
				on_off : in std_logic;
				cnt_start : out std_logic;
				cnt_done : in std_logic;
				next_pattern : out std_logic;
				led_pattern : in std_logic_vector(7 downto 0);
				led : out std_logic_vector(7 downto 0)
		);
		end component;


		
begin

	led_timer_inst: led_timer 
	port map
	(
		clk=>clk,
		rst=>rst,
		cnt_start=>cnt_start,
		cnt_done=>cnt_done,
		cnt_value=>cnt_value
		
	);

	led_buffer_inst: led_buffer
	port map
	(
		clk=>clk,
		rst=>rst,
		buffer_clear=>buffer_clear,
		buffer_write=>buffer_write,
		buffer_data=>buffer_data,
		next_pattern=>next_pattern,
		led_pattern=>led_pattern
		
	);

	led_controller_inst: led_controller
	port map
	(
		clk=>clk,
		rst=>rst,
		on_off=>on_off,
		cnt_start=>cnt_start,
		cnt_done=>cnt_done,
		next_pattern=>next_pattern,
		led_pattern=>led_pattern,
		led=>led
				
	);
	
	process(clk)
	begin
		if clk'event and clk='1' then
			if rst = '1' then
				ack		<= '0';
				
			else
				if wslvi.stb = '1' and wslvi.cyc = '1' then
					if wslvi.we='1' then
						if (wslvi.adr(2)='1') then -- for target value counter register, 2nd bit 1 for 4
						cnt_value <= dec_wb_dat(wslvi.sel,wslvi.dat)(31 downto 0);
						end if;
						if (wslvi.adr(2)='0') then -- for target value counter register, 2nd bit 1 for 4
						--buffer_data <= dec_wb_dat(wslvi.sel,wslvi.dat)(23 downto 16);
						ctrl_flgs <= dec_wb_dat(wslvi.sel,wslvi.dat)(31 downto 0);
						buffer_data  <= ctrl_flgs(23 downto 16);
						buffer_write<= ctrl_flgs(24);
						buffer_clear<= ctrl_flgs(8);
						on_off<= ctrl_flgs(0);
						end if;
						
					end if;
					if ack = '0' then
						ack	<= '1';
					else
						ack	<= '0';
					end if;
			
					
				else
					ack <= '0';
					if buffer_write = '1' then
						buffer_write	<= '0';
						ctrl_flgs(24)   <= '0';
					end if;
					if on_off = '1' then
						on_off	<= '0';
						ctrl_flgs(0)   <= '0';
					end if;
					if buffer_clear = '1' then
						buffer_clear <= '0';
						ctrl_flgs(8)   <= '0';
					end if;
					
		
				end if;
				
			end if;
		end if;
	end process;

	wslvo.ack	<= ack;
	wslvo.wbcfg	<= wb_membar(memaddr, addrmask);

end Behavioral;
