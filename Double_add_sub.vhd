----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.08.2020 14:37:32
-- Design Name: 
-- Module Name: Double_add_sub - Structural
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Double_add_sub is
    port (FP_a: in std_logic_vector(63 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(63 downto 0);
          add_sub: in std_logic;
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic;
          FP_z: out std_logic_vector(63 downto 0));
end Double_add_sub;

architecture Structural of Double_add_sub is
component Alignment_compare_E is
    port (E_a: in std_logic_vector(10 downto 0); --E is supposed to be biased.
          E_b: in std_logic_vector(10 downto 0);
          shift_M_a: out std_logic_vector(10 downto 0);
          shift_M_b: out std_logic_vector(10 downto 0);
          max_E: out std_logic_vector(10 downto 0));
end component;

component mantissa_add_sub is
    --The sum is perfomed in 55 bits, 1 bit sign + 1 guardian bit + implicit 1 before mantissa + 52 bit matissa = 55 bit.
    --The rapresentation is sign magnitude so conversion to two's complement could be necessary.
    port (M_a: in std_logic_vector(54 downto 0);
          M_b: in std_logic_vector(54 downto 0);
          add_sub: in std_logic;
          sum_M: out std_logic_vector(54 downto 0);
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic);
end component;

component Mantissa_shifter is
    --1 bit sign + 1 hidden bit + 52 bit mantissa = 54 bits.
    port (M_a: in std_logic_vector(53 downto 0);
          M_b: in std_logic_vector(53 downto 0);
          shift_amt_a: in std_logic_vector(10 downto 0);
          shift_amt_b: in std_logic_vector(10 downto 0);
          M_a_shifted: out std_logic_vector(53 downto 0);
          M_b_shifted: out std_logic_vector(53 downto 0));
end component;

component Generic_normalization_double_unit is
    generic (N: integer:= 8);
    port (M: in std_logic_vector(N-1 downto 0);
          E: in std_logic_vector (10 downto 0);
          OMZ: in std_logic;                  --This flag is used to handle total zero mantissa. 
          norma_M: out std_logic_vector(51 downto 0);
          norma_E: out std_logic_vector(10 downto 0));
end component;

signal shift_amt_a, shift_amt_b: std_logic_vector(10 downto 0);
signal max_E: std_logic_vector(10 downto 0);
signal sign_mantissa_a,  sign_mantissa_b: std_logic_vector(53 downto 0);
signal post_shift_ma, post_shift_mb: std_logic_vector(53 downto 0);
signal pre_computation_m_a, pre_computation_m_b: std_logic_vector (54 downto 0);
signal post_computation_m: std_logic_vector(54 downto 0);
signal prenormalization_m : std_logic_vector(53 downto 0);

signal tmp_FP_z: std_logic_vector (63 downto 0);
signal tmp_OMZ, tmp_carry: std_logic;
begin

--Find the amount of shifting in order to align mantissa and exponents.
alignment_amt_stage: Alignment_compare_E port map (FP_a(62 downto 52), FP_b(62 downto 52), shift_amt_a, shift_amt_b, max_E);
--Shift the mantissa, consider signed mantissa.
alignment_shift_stage: Mantissa_shifter port map(sign_mantissa_a, sign_mantissa_b, shift_amt_a, shift_amt_b, post_shift_ma, post_shift_mb);
--Perform addition/subctraction.
computation_stage: mantissa_add_sub port map(pre_computation_m_a, pre_computation_m_b, add_sub, post_computation_m, tmp_carry, underflow, tmp_OMZ);
--Normalization.
normalization_stage: Generic_normalization_double_unit generic map(54)
                                                         port map(prenormalization_m, max_E, tmp_OMZ, tmp_FP_z(51 downto 0), tmp_FP_z(62 downto 52));
----------------------Adjust form from shift stage to add/sub stage-------------------------------------------------------------------------

--Create the pre computation Mantissa :  54=> sign, 53=> '0' ,52 => IEE 754 hidden bit, 51 downto 0 => mantissa value.

pre_computation_m_a(54) <= post_shift_ma(53);                   --Attach sign from shift stage.
pre_computation_m_a(53) <= '0';                                 --Guardian bit, avoid propagation to sign bit when summing.
pre_computation_m_a(52 downto 0) <= post_shift_ma(52 downto 0); --Attach shifted mantissa.
pre_computation_m_b(54) <= post_shift_mb(53);
pre_computation_m_b(53) <= '0';
pre_computation_m_b(52 downto 0) <= post_shift_mb(52 downto 0);

--------------------------------------------------------------------------------------------------------------------------------------------

------------------------Build the signed matissa.(-1)^S*|M|--------------------------------------------------------------------------------
sign_mantissa_a(53) <= FP_a(63);
sign_mantissa_a(51 downto 0) <= FP_a(51 downto 0);
sign_mantissa_b(53) <= FP_b(63);
sign_mantissa_b(51 downto 0) <= FP_b(51 downto 0);
--Attach the hidden bit (52th bit) follwing the IEEE 754 standard.
sign_mantissa_a(52) <= '0' when FP_a(62 downto 52) = "00000000000" else 
                       '1';
sign_mantissa_b(52) <= '0' when FP_b(62 downto 52) = "00000000000" else 
                           '1';

----------------------Adjust form from add/sub to normalization stage-----------------------------------------------------------------------
prenormalization_m  <= post_computation_m(53 downto 0); --Includes the hidden bit.
--------------------------------------------------------------------------------------------------------------------------------------------

--Add sign to final result.
tmp_FP_z(63) <= post_computation_m(54);

--Connect outputs.
FP_z <= tmp_FP_z when tmp_OMZ = '0' else
        (others =>'0'); 
--Flags.
OMZ <= tmp_OMZ;
overflow <= tmp_carry;

end Structural;
