
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity test_top is
	Port (clk					: in  STD_LOGIC;
			data_in				: in  unsigned(255 downto 0);
			data_out				: out unsigned(255 downto 0)
        );
end test_top;

architecture Behavioral of test_top is

--signal clk_in		: STD_LOGIC;
--signal DATA_IN		: unsigned(255 DOWNTO 0);
--signal DATA_out	: STD_LOGIC_VECTOR(255 DOWNTO 0);
signal a0			: unsigned(63 downto 0);
signal i_out		: natural range 0 to 23;

COMPONENT math
	Port (clk			: in  STD_LOGIC;
			data_in		: in  unsigned(255 downto 0);
			data_out		: out unsigned(255 downto 0);
			a0						: out unsigned(63 downto 0);
			i_out						: out natural range 0 to 23;
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
			b14					: out unsigned(63 downto 0)
        );
END COMPONENT;

begin

u1 : math
    PORT MAP (
			clk		=>clk,
			data_in	=>data_in,
			data_out	=>data_out,
			a0			=> a0,
			i_out		=> i_out
    );
end Behavioral;