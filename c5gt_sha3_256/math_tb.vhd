library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity math_tb is

end math_tb;

architecture Behavioral of math_tb is

signal clk_in		: STD_LOGIC;
signal DATA_IN		: unsigned(255 DOWNTO 0);
signal DATA_out	: unsigned(255 DOWNTO 0);
signal a0			: unsigned(63 downto 0);
signal i_out		: natural range 0 to 23;
signal k_out		: natural range 0 to 23;
signal res_1_out	: unsigned(255 downto 0);
signal res_2_out	: unsigned(255 downto 0);
signal FSM_out		: STD_LOGIC_VECTOR(1 downto 0);

signal b00	: unsigned(63 downto 0);
signal b01	: unsigned(63 downto 0);
signal b02	: unsigned(63 downto 0);
signal b03	: unsigned(63 downto 0);
signal b04	: unsigned(63 downto 0);
signal b10	: unsigned(63 downto 0);
signal b11	: unsigned(63 downto 0);
signal b12	: unsigned(63 downto 0);
signal b13	: unsigned(63 downto 0);
signal b14	: unsigned(63 downto 0);

signal c0	: unsigned(63 downto 0);
signal c1	: unsigned(63 downto 0);
signal c2	: unsigned(63 downto 0);
signal c3	: unsigned(63 downto 0);
signal c4	: unsigned(63 downto 0);

signal d0	: unsigned(63 downto 0);

COMPONENT math
	Port (clk			: in  STD_LOGIC;
			data_in		: in  unsigned(255 downto 0);
			data_out		: out unsigned(255 downto 0);
			a0						: out unsigned(63 downto 0);
			i_out					: out natural range 0 to 23;
			k_out					: out natural range 0 to 23;
			res_1_out			: out unsigned(255 downto 0);
			res_2_out			: out unsigned(255 downto 0);
			FSM_out				: out STD_LOGIC_VECTOR(1 downto 0);
			b00					: out unsigned(63 downto 0);
			b01					: out unsigned(63 downto 0);
			b02					: out unsigned(63 downto 0);
			b03					: out unsigned(63 downto 0);
			b04					: out unsigned(63 downto 0);
			b10					: out unsigned(63 downto 0);
			b11					: out unsigned(63 downto 0);
			b12					: out unsigned(63 downto 0);
			b13					: out unsigned(63 downto 0);
			b14					: out unsigned(63 downto 0);
			c0_out				: out unsigned(63 downto 0);
			c1_out				: out unsigned(63 downto 0);
			c2_out				: out unsigned(63 downto 0);
			c3_out				: out unsigned(63 downto 0);
			c4_out				: out unsigned(63 downto 0);
			d0_out				: out unsigned(63 downto 0)
        );
END COMPONENT;

begin

u1 : math
    PORT MAP (
			clk		=>clk_in,
			data_in	=>DATA_IN,
			data_out	=>DATA_out,
			a0			=> a0,
			i_out		=> i_out,
			k_out		=>k_out,
			res_1_out	=>res_1_out,
			res_2_out	=>res_2_out,
			FSM_out		=>FSM_out,
			b00			=> b00,
			b01		=> b01,
			b02		=> b02,
			b03		=> b03,
			b04		=> b04,
			b10		=> b10,
			b11		=> b11,
			b12		=> b12,
			b13		=> b13,
			b14		=> b14,
			c0_out	=>c0,
			c1_out	=>c1,
			c2_out	=>c2,
			c3_out	=>c3,
			c4_out	=>c4,
			d0_out	=>d0	
    );
	 
	PROCESS
    BEGIN
        clk_in <= '1'; WAIT FOR 5 ns;
        clk_in <= '0'; WAIT FOR 5 ns;
    END PROCESS;
	 
	 
	 PROCESS
    BEGIN
	 
--------transform your input string from keyboard to HEX code with help of ASCII table and fill 64 digits below----
	 
		  data_in <= x"3030303030303030303030303030303030303030303030303030303030303030"; WAIT FOR 1000 ns;-----32 zeroes - '0'
		  
---------------------00000000000000000000000000000000

		  data_in <= x"3131313131313131313131313131313131313131313131313131313131313131"; WAIT FOR 1000 ns;-----32 ones - '1'
		  
---------------------11111111111111111111111111111111

 
----    data_in <= (250 =>'1', 249 =>'1', others=>'0'); WAIT FOR 1000 ns;----empty
--		  data_in <= x"0600000000000000000000000000000000000000000000000000000000000000"; WAIT FOR 1000 ns;-----empty  
--		  data_in <= x"3006000000000000000000000000000000000000000000000000000000000000"; WAIT FOR 1000 ns;-----'0'
--		  data_in <= x"2006000000000000000000000000000000000000000000000000000000000000"; WAIT FOR 1000 ns;-----'space'
--		  data_in <= x"2106000000000000000000000000000000000000000000000000000000000000"; WAIT FOR 1000 ns;-----'!'
--		  data_in <= x"6162630600000000000000000000000000000000000000000000000000000000"; WAIT FOR 1000 ns;-----'abc'
		  
--		  data_in <= (others=>'0'); WAIT FOR 1000 ns;
    END PROCESS;

end Behavioral;