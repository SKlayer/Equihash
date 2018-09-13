----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Logotorix
-- 
-- Create Date:    03/05/2018 
-- Design Name: 
-- Module Name:    Lg_Mux_nL1w_T1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
--
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.LgGlobal_pkg.all;	

entity Lg_Mux_nL1w_T1 is
generic(
	Num				: Positive := 3;
	Syn				: string := "true" -- "true" "false"
);
port (
	Di			: in	unsigned(Num-1 downto 0);
	Do			: out	std_logic;
	Sel			: in	Natural;
	
	clk			: in	std_logic;
	aclr		: in	std_logic
);
end Lg_Mux_nL1w_T1;

architecture rtl of Lg_Mux_nL1w_T1 is
--============================ constant declare ============================--
constant nL			: Natural := Fnc_Int2Wd(Num-1);
--======================== Altera component declare ========================--

--===================== user-defined component declare =====================--

--============================= signal declare =============================--
signal sgn_Mux		: unsigned(2**(nL+1)-2 downto 0);

type typ_Sel		is array (natural range<>) of unsigned(nL-1 downto 0);
signal sgn_Sel		: typ_Sel(nL-1 downto 0);
--============================ function declare ============================--

begin

i0200: for i in 0 to 2**nL-1 generate
	sgn_Mux(i) <= Di(i);
end generate i0200;

i0300: for i in 0 to nL-1 generate
	i0310: if(i=0)generate
		sgn_Sel(0) <= to_unsigned(Sel,nL);
	end generate i0310;
	i0320: if(i/=0)generate
		process(clk,aclr)
		begin
			if(aclr='1')then
				sgn_Sel(i) <= (others => '0');
			elsif(rising_edge(clk))then
				sgn_Sel(i) <= sgn_Sel(i-1);
			end if;
		end process;
	end generate i0320;
end generate i0300;

--i0100: for i in nL-1 downto 0 generate
--	i0110: for j in 0 to 2**i-1 generate
--		process(clk, aclr)
--		begin
--			if(aclr = '1')then
--				sgn_Mux(j+(2**(nL+1)-2**(nL-(nL-1-i)))) <= (others => '0');
--			elsif(rising_edge(clk))then
--				if(sgn_Sel(nL-1-i)(i) = '1')then
--					sgn_Mux(j+(2**(nL+1)-2**(nL-(nL-1-i)))) <= sgn_Mux(j*2+(2**(nL+1)-2**(nL-(nL-1-i)+1)));
--				else
--					sgn_Mux(j+(2**(nL+1)-2**(nL-(nL-1-i)))) <= sgn_Mux(j*2+1+(2**(nL+1)-2**(nL-(nL-1-i)+1)));
--				end if;
--			end if;
--		end process;
--	end generate i0110;
--end generate i0100;

t01: if (Syn = "true") generate
	i0100: for i in 0 to nL-1 generate
		i0110: for j in 0 to 2**(nL-1-i)-1 generate
			process(clk, aclr)
			begin
				if(aclr = '1')then
					sgn_Mux(j+(2**(nL+1)-2**(nL-i))) <= '0';
				elsif(rising_edge(clk))then
					if(sgn_Sel(i)(i) = '0')then
						sgn_Mux(j+(2**(nL+1)-2**(nL-i))) <= sgn_Mux(j*2+(2**(nL+1)-2**(nL-i+1)));
					else
						sgn_Mux(j+(2**(nL+1)-2**(nL-i))) <= sgn_Mux(j*2+1+(2**(nL+1)-2**(nL-i+1)));
					end if;
				end if;
			end process;
		end generate i0110;
	end generate i0100;
end generate t01;

t02: if (Syn = "false") generate
	i0100: for i in 0 to nL-1 generate
		i0110: for j in 0 to 2**(nL-1-i)-1 generate
			sgn_Mux(j+(2**(nL+1)-2**(nL-i))) <= sgn_Mux(j*2+(2**(nL+1)-2**(nL-i+1))) when (sgn_Sel(0)(i) = '0') else
															sgn_Mux(j*2+1+(2**(nL+1)-2**(nL-i+1)));
		end generate i0110;
	end generate i0100;
end generate t02;

Do <= sgn_Mux(2**(nL+1)-2);

end rtl;
