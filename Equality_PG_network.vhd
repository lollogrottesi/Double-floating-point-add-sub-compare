----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2020 14:18:26
-- Design Name: 
-- Module Name: Equality_PG_network - Dataflow
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

entity Equality_PG_network is
     Generic (N: integer:= 32);
     Port (A: in std_logic_vector(N-1 downto 0);
           B: in std_logic_vector(N-1 downto 0);
           p: out std_logic_vector(N-1 downto 0);
           g: out std_logic_vector(N-1 downto 0));
end Equality_PG_network;

architecture Dataflow of Equality_PG_network is

begin
p <= A xor B;
g <= A and B;
end Dataflow;
