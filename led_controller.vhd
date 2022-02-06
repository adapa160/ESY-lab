-- See the file "LICENSE" for the full license governing this code. --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.lt16x32_global.all;
use work.wishbone.all;
use work.config.all;

entity led_controller is
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
end led_controller;
	
architecture Behavioral of led_controller is

	signal led_reg : std_logic_vector(7 downto 0);
	signal onoff_temp : integer := 0;
		
begin

	process(clk) is

	--variable cnt_start : std_logic := '0';
	--variable int_count : integer := 0;
			
	begin
		if clk'event and clk='1' then
			if (rst = '1') then
			   if (on_off = '0') then
			        led_reg <= "00000000";
				 cnt_start <= '0';
				 next_pattern <= '0';
			    end if;	
			    
				led_reg <= "00000000";
				cnt_start <= '0';
				next_pattern <= '0';
				 
			else
			     if on_off = '0' then
			        if cnt_done = '0' then
			           led_reg <= led_reg;
			           cnt_start <= '0';
				   next_pattern <= '0';
				   
				 elsif (cnt_done = '1') then
				   
				   led_reg <= led_pattern;
			           cnt_start <= '1';
				   next_pattern <= '1';
				 end if; 
				 
			     elsif on_off = '1'then
				       led_reg <= led_pattern;
			               cnt_start <= '1';
				       next_pattern <= '1';
  
			    end if;
			end if; 
			
			led <= led_reg;
		end if;
	end process;


	--wslvo.dat(31 downto 0)	<= (others=>'0');
	
	--wslvo.ack	<= ack;
	--wslvo.wbcfg	<= wb_membar(memaddr, addrmask);

end Behavioral;

