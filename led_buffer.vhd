-- See the file "LICENSE" for the full license governing this code. --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.lt16x32_global.all;
use work.wishbone.all;
use work.config.all;

entity led_buffer is
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
	end led_buffer;

architecture Behavioral of led_buffer is
 
		type ram_type is array (0 to RAM_DEPTH - 1) of
		  std_logic_vector(buffer_data'range);
		signal ram : ram_type;
	   
		--signal rd_check : std_logic;
		subtype index_type is integer range ram_type'range;
		signal ptr_write : index_type;
		signal ptr_read : index_type;
		signal ptr_last : index_type;
	   
			   
		-- Increment and wrap
		procedure incr(signal index : inout index_type) is
		begin
		  if index = index_type'high then
			index <= index_type'low;
		  else
			index <= index + 1;
		  end if;
		end procedure;
	   
	  begin
	   
		   
		-- If buffer_write is set, update ptr_write and ptr_last; also update the data to RAM
		PROC_WRITE : process(clk)
		begin
		  if rising_edge(clk) then
			if (rst = '1' or buffer_clear = '1') then
				ptr_write <= 0;
				ptr_last <= -1;
				
			else
	   
			  if buffer_write = '1' then 
			  	ram(ptr_write) <= buffer_data;
				incr(ptr_write);
				if (ptr_last /= 15) then
				ptr_last <= ptr_write;
				else 
				ptr_last <= ptr_last;
				end if;
			  end if;
	   
			end if;
		  end if;
		end process;
	   
		-- If next_pattern is set, update ptr_read; also read the data from RAM
		PROC_READ : process(clk)
		begin
		  if rising_edge(clk) then
			if (rst = '1' or buffer_clear = '1') then
					--ram <= ("00000000", "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
					ptr_read <= 0;
					--ptr_read <= ptr_read;
					--led_pattern <= "00000000";
					--rd_check <= '0';
				
			else
			    --rd_check <= '0';
	   			  if next_pattern = '1' then
			   if ( ptr_last = -1) then
			   ptr_read <= ptr_read;
			   led_pattern <= "00000000";
			   
			   elsif (ptr_read <= ptr_last) then
			     led_pattern <= ram(ptr_read);
				incr(ptr_read);
			  else
				ptr_read <=0;
				--rd_check <= '1';
			  end if;
			  --if (ptr_read = ptr_last) then
				--ptr_read <= 0;
			  --end if;
	   end if;
			end if;
		  end if;
		end process;
	      
end Behavioral;
