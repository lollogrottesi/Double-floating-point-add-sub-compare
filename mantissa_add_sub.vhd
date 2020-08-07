----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 09:40:10
-- Design Name: 
-- Module Name: mantissa_add_sub - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
 use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mantissa_add_sub is
    --The sum is perfomed in 55 bits, 1 bit sign + 1 guardian bit + implicit 1 before mantissa + 52 bit matissa = 55 bit.
    --The rapresentation is sign magnitude so conversion to two's complement could be necessary.
    port (M_a: in std_logic_vector(54 downto 0);
          M_b: in std_logic_vector(54 downto 0);
          add_sub: in std_logic;
          sum_M: out std_logic_vector(54 downto 0);
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic);
end mantissa_add_sub;

architecture Structural of mantissa_add_sub is
component c_l_addr IS
    generic (N: integer:= 25);
    PORT
        (
         x_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
end component;

component Equality_check_unit is
    Generic (N: integer:= 32);
    Port (A: in std_logic_vector (N-1 downto 0);
          B: in std_logic_vector (N-1 downto 0);
          A_eq_B: out std_logic);
end component;

constant sign    : integer := 54;
--constant num_bit : integer := 25;
signal signed_M_b, signed_M_a, tmp_signed_M_b, one_compl_M_a, one_compl_M_b: std_logic_vector (sign downto 0);
signal operation: std_logic_vector(sign downto 0);
signal check_OMZ: std_logic_vector(53 downto 0);
signal tmp_out, one_compl_out, sign_magn_out  : std_logic_vector(sign downto 0);
begin
--Adder instantiation.
look_ahead_adder: c_l_addr generic map (55)
                           port map(signed_M_a, tmp_signed_M_b, add_sub, tmp_out, overflow);

--Check unit is implemented to detect all zero pattern in the output mantissa.
OMZ_comparator: Equality_check_unit generic map(54)
                                    port map (tmp_out (53 downto 0), check_OMZ, OMZ);
check_OMZ <= (others=>'0');


--Transform the sign magnitude notation in two's complement(signed), this operation is needed only in case of negative numbers.
one_compl_M_a(sign) <= M_a(sign);
one_compl_M_b(sign) <= M_b(sign);
one_compl_M_a(sign-1 downto 0) <= not M_a(sign-1 downto 0) when M_a(sign) = '1' else
                                  M_a(sign-1 downto 0);
one_compl_M_b(sign-1 downto 0) <= not M_b(sign-1 downto 0) when M_b(sign) = '1' else
                                  M_b(sign-1 downto 0);
signed_M_a <= std_logic_vector(unsigned(one_compl_M_a) + 1) when M_a(sign) = '1' else
              one_compl_M_a;
signed_M_b <= std_logic_vector(unsigned(one_compl_M_b) + 1) when M_b(sign) = '1' else
              one_compl_M_b;
              
--Two's complement if subctration.
operation <= (others => add_sub);              
tmp_signed_M_b <= signed_M_b xor operation;

--Underflow computation.
underflow <= (tmp_out(sign) and (not signed_M_a(sign)) and (not tmp_signed_M_b(sign))) or ((not tmp_out(sign)) and signed_M_a(sign) and tmp_signed_M_b(sign));

--If necessary retrasfrm back the two's complement into sign-magnitude.
one_compl_out (sign) <= tmp_out(sign);
one_compl_out(sign-1 downto 0) <= not tmp_out(sign-1 downto 0) when tmp_out(sign)='1' else
                                  tmp_out(sign-1 downto 0);
sign_magn_out <= std_logic_vector(unsigned(one_compl_out) + 1) when tmp_out(sign) = '1' else
                 one_compl_out;
sum_M <= sign_magn_out;

end Structural;
