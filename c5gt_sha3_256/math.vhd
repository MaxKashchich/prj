
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity math is
	Port (clk					: in  STD_LOGIC;
			data_in				: in  unsigned(255 downto 0);
			data_out				: out unsigned(255 downto 0);
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
end math;

architecture Behavioral of math is


type Tstates is (idle, absorb, squeez);
type type_1 is array (0 to 4) of unsigned(63 downto 0);
type type_arr is array (0 to 4, 0 to 4) of unsigned(63 downto 0);

type type_r is array (0 to 4, 0 to 4) of natural range 0 to 63;----------rotation

type type_rc is array (0 to 23) of unsigned(63 downto 0);--------------rc coeff

signal FSM_state 		: Tstates:=idle;

signal res				: unsigned(63 downto 0);

signal temp_2			: unsigned(7 downto 0);

signal A, res_1, B, C	: type_arr;
signal res_2, res_3	: unsigned(255 downto 0);
signal r					: type_r;-------------------rotation
signal RC				: type_rc;---------rc

signal a1 : type_arr;
signal rc1 : type_rc;
signal b1 : type_arr:=(others=>(others=>(others=>'0')));
signal c1 : type_1:=(others=>(others=>'0'));
signal d1 : type_1:=(others=>(others=>'0'));

signal i,j,k,l,m,n,o,p			: natural range 0 to 30 := 0;
signal i_1			: natural range 0 to 30 := 0;

function  order  (a : unsigned) return unsigned is

variable a1 : unsigned(63 downto 0):=a;
variable b1 : unsigned(63 downto 0):=(others=>'0');

begin

	for i in 0 to 7 loop
		b1(((i+1)*8-1) downto i*8):=a1((((7-i)+1)*8-1) downto (7-i)*8);
	end loop;
	
return b1;

end order;


function  Keccak  (a : type_arr; RC : unsigned; i : natural) return type_arr is
variable a1 : type_arr:=a;
variable rc1 : unsigned(63 downto 0):=RC;
variable b1 : type_arr:=(others=>(others=>(others=>'0')));
variable c1 : type_1:=(others=>(others=>'0'));
variable d1 : type_1:=(others=>(others=>'0'));
variable r : type_r;
variable i1 : natural:=i;
begin
r := ((0,1,62,28,27),
		(36,44,6,55,20),
		(3,10,43,25,39),
		(41,45,15,21,8),
		(18,2,61,56,14));
		
---thetha------------

		if i1=0 then
			for j in 0 to 4 loop
				c1(j):=order(a1(0,j)) xor order(a1(1,j)) xor order(a1(2,j)) xor order(a1(3,j)) xor order(a1(4,j));
			end loop;
		else
			for j in 0 to 4 loop
				c1(j):=a1(0,j) xor a1(1,j) xor a1(2,j) xor a1(3,j) xor a1(4,j);
			end loop;
		end if;

		d1(0) := c1(4) xor (c1(1) rol 1);
		d1(1) := c1(0) xor (c1(2) rol 1);
		d1(2) := c1(1) xor (c1(3) rol 1);
		d1(3) := c1(2) xor (c1(4) rol 1);
		d1(4) := c1(3) xor (c1(0) rol 1);
		
	if i1=0 then
		for k in 0 to 4 loop
			for l in 0 to 4 loop
					a1(k,l):=order(a1(k,l)) xor d1(l);
			end loop;
		end loop;
	else
		for k in 0 to 4 loop
			for l in 0 to 4 loop
					a1(k,l):=a1(k,l) xor d1(l);
			end loop;
		end loop;
	end if;
---rho-pi------------
	for m in 0 to 4 loop
		for n in 0 to 4 loop
			b1(((2*n+3*m) mod 5), m) := a1(m,n) rol r(m,n);
		end loop;
	end loop;
---chi--------------
	for o in 0 to 4 loop
		for p in 0 to 4 loop
			a1(o,p) := b1(o,p) xor ((not b1(o ,((p+1) mod 5))) and b1(o ,((p+2) mod 5)));	
		end loop;
	end loop;
---iot---------------
	a1(0,0) := a1(0,0) xor RC;

return a1;

end Keccak;



begin
	  
process(clk)
begin
if rising_edge(clk) then

A<=((unsigned(data_in(255 downto 192)), unsigned(data_in(191 downto 128)), unsigned(data_in(127 downto 64)), unsigned(data_in(63 downto 0)), (58 =>'1', 57 =>'1', others=>'0')),---(0=>'1',others=>'0')
	 ((others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0')),
	 ((others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0')),
	 ((others=>'0'), (7=>'1', others=>'0'), (others=>'0'), (others=>'0'), (others=>'0')),
	 ((others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), (7 =>'0',others=>'0')));-----------------7-'1'
	 
RC <= (x"0000000000000001",
		 x"0000000000008082",
		 x"800000000000808A",
		 x"8000000080008000",
		 x"000000000000808B",
		 x"0000000080000001",
		 x"8000000080008081",
		 x"8000000000008009",
		 x"000000000000008A",
		 x"0000000000000088",
		 x"0000000080008009",
		 x"000000008000000A",
		 x"000000008000808B",
		 x"800000000000008B",
		 x"8000000000008089",
		 x"8000000000008003",
		 x"8000000000008002",
		 x"8000000000000080",
		 x"000000000000800A",
		 x"800000008000000A",
		 x"8000000080008081",
		 x"8000000000008080",
		 x"0000000080000001",
		 x"8000000080008008");
		 
case FSM_state is
	when idle =>
		FSM_state<=absorb;
	if i=0 then
		B<=A;
--	else
--		B<=B;
	end if;
	when absorb =>
		if i = 23 then
			i<=0;
			FSM_state<=squeez;
		else
			i<=i+1;
			FSM_state<=absorb;
		end if;
		B <= Keccak(B, RC(i), i);
	when squeez =>
		FSM_state<=idle;
		data_out <= order(B(0,0))&order(B(0,1))&order(B(0,2))&order(B(0,3));
end case;
end if;
end process;

a0 <= RC(i_1);
i_out <= i;

			b00	<= order(B(0,0));
			b01	<= order(B(0,1));
			b02	<= order(B(0,2));
			b03	<= order(B(0,3));
			b04	<= order(B(0,4));
			b10	<= order(B(1,0));
			b11	<= order(B(1,1));
			b12	<= order(B(1,2));
			b13	<= order(B(1,3));
			b14	<= order(B(1,4));
			
			c0_out	<= d1(0);
			c1_out	<= d1(1);
			c2_out	<= d1(2);
			c3_out	<= d1(3);
			c4_out	<= d1(4);
			d0_out	<= order(a1(0,4));

--data_out <= (a1(0,0))&(a1(0,1))&(a1(0,2))&(a1(0,3));

res_2_out			<= res_2;

end Behavioral;