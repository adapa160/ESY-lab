-- See the file "LICENSE" for the full license governing this code. --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.lt16x32_global.all;
use work.wishbone.all;
use work.config.all;

entity swbtn is
	generic(
		memaddr		:	generic_addr_type;--:= CFG_BADR_SWBTN;
		addrmask	:	generic_mask_type --:= CFG_MADR_SWBTN
	);
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		btn		: in  std_logic_vector(4 downto 0);
		sw		: in  std_logic_vector(7 downto 0);
		switchint      : out std_logic;
		wslvi	: in  wb_slv_in_type;
		wslvo	: out wb_slv_out_type
		
	);
end swbtn;

architecture Behavioral of swbtn is

	signal data : std_logic_vector(31 downto 0); --:= (others=>'0');
	signal ack	: std_logic;
	signal switch_int	: std_logic;
begin

	process(clk)
	 variable swbt : std_logic_vector(31 downto 0):=(others=>'0');
	begin
	swbt(7 downto 0) := sw;
        swbt (12 downto 8):= btn;
        swbt (31 downto 13):=(others=>'0');
		if clk'event and clk='1' then
			if rst = '1' then
				ack		<= '0';
				data	<= "00000000000000000000000000000000";
			else
				if wslvi.stb = '1' and wslvi.cyc = '1' then
					if wslvi.we='0' then
						--data(15 downto 0) <= sw;	--<= dec_wb_dat(wslvi.sel,wslvi.dat)(7 downto 0);
					        --data(20 downto 16) <= btn;
					        --data(31 downto 21) <= (others=>'0');
					        data <= enc_wb_dat(sel2adr(wslvi.sel),decsz(wslvi.sel),swbt);
					end if;
					if ack = '0' then
						ack	<= '1';
					else
						ack	<= '0';
					end if;
				else
					ack <= '0';
				end if;
			end if;
		end if;
	end process;

process(sw,btn,clk)
       begin
             if clk'event and clk='1' then 	
                     if rst = '1' then
				switch_int <= '0';
		     else
		     	   if sw'event or btn'event then
		     	      if switch_int <= '0' then
		     	         switch_int <= '1';
		     	      end if;
		     	   else
		     	      if switch_int <= '1' then
		     	        switch_int <= '0';
		     	      end if;
		     	   end if;
		      end if;
	     end if;
end process;	     	      	        
		     	         
		     	       

	wslvo.dat(31 downto 0) <= data;
	wslvo.ack	<= ack;
	wslvo.wbcfg	<= wb_membar(memaddr, addrmask);
	switchint       <= switch_int;

end Behavioral;

