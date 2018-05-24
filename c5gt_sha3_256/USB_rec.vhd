
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity USB_rec is
	Port (clk			: in  STD_LOGIC;
			data_usb		: inout  STD_LOGIC_VECTOR(31 downto 0);
			TE_n			: in  STD_LOGIC;
			RF_n			: in  STD_LOGIC;
			OE_n			: out STD_LOGIC;
			WR_n			: out STD_LOGIC;
			RD_n			: out STD_LOGIC;
			BE				: in  STD_LOGIC_VECTOR(3 downto 0);
---------------------internal signals-------------
			TX_en			: in  STD_LOGIC;
			wr_en_fifo	: out STD_LOGIC;
			fifo_full	: in STD_LOGIC;
			rd_en_fifo	: out STD_LOGIC;
			fifo_empty	: in STD_LOGIC;
			data_tx		: in STD_LOGIC_VECTOR(31 downto 0);
			data_out		: out STD_LOGIC_VECTOR(255 downto 0)
        );
end USB_rec;

architecture Behavioral of USB_rec is

----component single_port_ram is
----	generic 
----	(DATA_WIDTH : natural := 8;--32;
----	 ADDR_WIDTH : natural := 11);
----	port 
----	(clk		: in std_logic;
----	 addr		: in natural range 0 to 2**ADDR_WIDTH - 1;
----	 data		: in std_logic_vector((DATA_WIDTH-1) downto 0);
----	 we		: in std_logic := '1';
----	 q			: out std_logic_vector((DATA_WIDTH -1) downto 0)
----	 );
----end component;
--
----type Tstring is array (0 to hor_res-1) of std_logic_vector(31 downto 0);
--type Tstates is (idle, reading, writing, stop);
--
--signal FSM_state 		: Tstates:=reading;
--signal hor_cnt			: natural range 0 to 2000 := 0;
--
--signal we				: STD_LOGIC := '0';
--signal RD, WR, OE				: STD_LOGIC := '0';
--signal data_str_out	: STD_LOGIC_VECTOR(7 downto 0);
--
--signal first			: unsigned(255 downto 0):=x"2523648240000001ba344d80000000086121000000000013bb00000000000013";
--signal second			: unsigned(255 downto 0):=x"2523648240000001ba344d80000000086121000000000013a700000000000013";
--signal res				: unsigned(255 downto 0);
--signal res1				: unsigned(255 downto 0);
--signal temp				: unsigned(255 downto 0);
--constant modulus		: unsigned(255 downto 0):=x"0000000000000000000000000000000000000000000000000000000000000010";--0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
--
begin
--
--process(clk)
--begin
--if falling_edge(clk) then
--	case FSM_state is
--	when idle			=>
--		if RF_n='0' then
--			FSM_state <= reading;
--			OE_n	<= '0';
--			WR_n	<= '1';
--			RD_n	<= '0';
--			RD		<= '0';
--			WR		<= '1';
--			OE		<= '0';
--		elsif TX_en = '1' and TE_n='0' then
--			FSM_state <= writing;
--			OE_n	<= '0';
--			WR_n	<= '0';
--			RD_n	<= '1';
--			RD		<= '1';
--			WR		<= '0';
--			OE		<= '0';
--		else
--			FSM_state <= idle;
--			OE_n	<= '1';
--			WR_n	<= '1';
--			RD_n	<= '1';
--			RD		<= '1';
--			WR		<= '1';
--			OE		<= '1';
--		end if;
--	when reading		=>
--		if cnt=cnt_number-1 then
--			cnt<=0;
--			FSM_state <= stop;
--			OE_n	<= '1';
--			WR_n	<= '1';
--			RD_n	<= '1';
--			RD		<= '1';
--			WR		<= '1';
--			OE		<= '1';
--		else
--			cnt<=cnt+1;
--			FSM_state <= reading;
--		end if;
--	when writing		=>
--		if cnt=cnt_number-1 then
--			cnt<=0;
--			FSM_state <= stop;
--			OE_n	<= '1';
--			WR_n	<= '1';
--			RD_n	<= '1';
--			RD		<= '1';
--			WR		<= '1';
--			OE		<= '1';
--		else
--			cnt<=cnt+1;
--			FSM_state <= writing;
--		end if;
--	when stop =>
--		FSM_state <= idle;
--		OE_n	<= '1';
--		WR_n	<= '1';
--		RD_n	<= '1';
--		RD		<= '1';
--		WR		<= '1';
--		OE		<= '1';
--	end case;
--end if;
--end process;
--
--process(clk)
--begin
--if rising_edge(clk) then
--	if RD='0' and OE = '0' then
--		data_out <= data_usb&data_usb&data_usb&data_usb&data_usb&data_usb&data_usb&data_usb;
--	end if;
--	data_usb<=data_tx;
--	
--end if;
--end process;




end Behavioral;