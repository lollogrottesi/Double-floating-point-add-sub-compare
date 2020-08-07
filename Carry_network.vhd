----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2020 14:23:42
-- Design Name: 
-- Module Name: Carry_network - Dataflow
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

entity Carry_network is
 Generic(N: integer:= 32); 
 Port (p: in std_logic_vector(N-1 downto 0);
       g: in std_logic_vector(N-1 downto 0);
       cin: in std_logic;
       cout: out std_logic);
end Carry_network;

architecture Dataflow of Carry_network is
signal carry: std_logic_vector(N downto 1);
begin
carry(1) <= g(0) or (p(0) and cin); 
    --ci+1 = gi + pi*ci
    recursive_carry:
        for i in 1 to N-1 generate
            carry (i+1) <= g(i) or (p(i) and carry(i));
        end generate recursive_carry;
cout <= carry (N);
end Dataflow;
