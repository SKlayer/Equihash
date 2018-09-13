----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Logotorix
-- 
-- Create Date:    21/05/2018 
-- Design Name: 
-- Module Name:    Lg_Mux_nL1b_T2 - Behavioral
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

entity Lg_Mux_nL1b_T2 is
generic(
	Num				: Positive := 3;
	Syn				: string := "true" -- "true" "false"
);
port (
	Di			: in	unsigned(Num-1 downto 0);
	Do			: out	std_logic;
	Sel			: in	unsigned(Num-1 downto 0);
	
	clk			: in	std_logic;
	aclr		: in	std_logic := '1'
);
end Lg_Mux_nL1b_T2;

architecture rtl of Lg_Mux_nL1b_T2 is
--============================ constant declare ============================--
constant nL		: Natural := Fnc_Int2Wd(Num-1);
--======================== Altera component declare ========================--

--===================== user-defined component declare =====================--

--============================= signal declare =============================--
signal sgn_Mux		: unsigned(2**(nL+1)-2 downto 0);
--============================ function declare ============================--

begin
--
i0200: for i in 0 to Num-1 generate
	sgn_Mux(i) <= Di(i) and Sel(i);
end generate i0200;

t01: if (2**nL /= Num) generate
	i0300: for i in Num to 2**nL-1 generate
		sgn_Mux(i) <= '0';
	end generate i0300;
end generate t01;

t02: if(syn = "true") generate
	i0100: for i in 0 to nL-1 generate
		i0110: for j in 0 to 2**(nL-1-i)-1 generate
			process(clk, aclr)
			begin
				if(aclr = '1')then
					sgn_Mux(j+(2**(nL+1)-2**(nL-i))) <= '0';
				elsif(rising_edge(clk))then
					sgn_Mux(j+(2**(nL+1)-2**(nL-i))) <= sgn_Mux(j*2+  (2**(nL+1)-2**(nL-i+1))) or 
														sgn_Mux(j*2+1+(2**(nL+1)-2**(nL-i+1)));
				end if;
			end process;
		end generate i0110;
	end generate i0100;
end generate t02;

t03: if(syn = "false") generate
	i0100: for i in 0 to nL-1 generate
		i0110: for j in 0 to 2**(nL-1-i)-1 generate
			sgn_Mux(j+(2**(nL+1)-2**(nL-i))) <= sgn_Mux(j*2+  (2**(nL+1)-2**(nL-i+1))) or 
												sgn_Mux(j*2+1+(2**(nL+1)-2**(nL-i+1)));
		end generate i0110;
	end generate i0100;
end generate t03;

Do <= sgn_Mux(2**(nL+1)-2);

end rtl;
