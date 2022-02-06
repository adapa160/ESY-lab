-- See the file "LICENSE" for the full license governing this code. --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.lt16x32_global.all;
use work.wishbone.all;
use work.config.all;

entity led_timer is
	
	port(
	clk : in std_logic;
	rst : in std_logic;
	cnt_start : in std_logic;
	cnt_done : out std_logic;
	cnt_value : in std_logic_vector(31 downto 0)
	);
	end led_timer;
	
architecture Behavioral of led_timer is

	signal ack	: std_logic;
	signal int_count : integer := 0;
	signal int_temp : integer := 1;
--	signal wslvi	:	wb_slv_in_type;
--	signal wslvo	:	wb_slv_out_type;
			
begin

	process(clk) is
		
	begin
		if clk'event and clk='1' then
			if rst = '1' then
				ack		<= '0';
				int_count <=  0;
				cnt_done <= '0';
				int_temp <= 0;
				 
			else			
				
			--if cnt_start'event then
					
				if (cnt_start = '1') then	--assigning cnt_value to int_count 
				   int_count <=  to_integer(unsigned(cnt_value));
				   int_temp <= 3; -- temporary variable to track cnt_done
				end if; 

			--end if;
		    	if (int_count /= 0) then --decrementing counter int_count if cnt_start is 1 and int_count value not reached to zero
						--if (int_count > 0) then   
						int_count <=  int_count - 1;			
						cnt_done <= '0';

				elsif (int_count = 0 and int_temp = 3) then -- generate interrrupt when counter value is reached
						--if cnt_value(31 downto 0) >= b"00000000000000000000000000000000" then
						cnt_done <= '1';
						--end if;
						int_temp <=  int_temp + 1;
				else
						cnt_done <= '0';
				end if;						
				--else
					 -- cnt_done <= '0';
			end if;
		
			--end if;
					
		end if; 
		
	end process;


	--wslvo.dat(31 downto 0)	<= (others=>'0');
	
	--wslvo.ack	<= ack;
	--wslvo.wbcfg	<= wb_membar(memaddr, addrmask);

end Behavioral;


