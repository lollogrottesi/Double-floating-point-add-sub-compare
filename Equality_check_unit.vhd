----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 10:20:36
-- Design Name: 
-- Module Name: Equality_check_unit - Dataflow
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

entity Equality_check_unit is
    Generic (N: integer:= 32);
    Port (A: in std_logic_vector (N-1 downto 0);
          B: in std_logic_vector (N-1 downto 0);
          A_eq_B: out std_logic);
end Equality_check_unit;

architecture Dataflow of Equality_check_unit is
signal A_xor_B: std_logic_vector(N-1 downto 0);
signal nor_network: std_logic_vector(N-3 downto 0);
begin
A_xor_B <= A xor B;
nor_network(0) <= A_xor_B (0) or A_xor_B(1);
A_equal_B:
    for i in 1 to N-3 generate
        nor_network(i) <= nor_network(i-1) or A_xor_B(i+1);
    end generate A_equal_B;

A_eq_B <= nor_network(N-3) nor A_xor_B(N-1);     
end Dataflow;
