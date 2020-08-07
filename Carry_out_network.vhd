----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2020 14:43:42
-- Design Name: 
-- Module Name: Carry_out_network - Structural
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

entity Carry_out_network is
 Generic(N: integer:= 32); 
 Port (A: in std_logic_vector(N-1 downto 0);
       B: in std_logic_vector(N-1 downto 0);
       cin: in std_logic;
       cout: out std_logic);
end Carry_out_network;

architecture Structural of Carry_out_network is
signal p,g: std_logic_vector(N-1 downto 0);

component Equality_PG_network is
     Generic (N: integer:= 32);
     Port (A: in std_logic_vector(N-1 downto 0);
           B: in std_logic_vector(N-1 downto 0);
           p: out std_logic_vector(N-1 downto 0);
           g: out std_logic_vector(N-1 downto 0));
end component;

component Carry_network is
 Generic(N: integer:= 32); 
 Port (p: in std_logic_vector(N-1 downto 0);
       g: in std_logic_vector(N-1 downto 0);
       cin: in std_logic;
       cout: out std_logic);
end component;

begin
PG_network: Equality_PG_network generic map (N) port map (A, B, p, g);
Carry: Carry_network generic map(N) port map (p, g, cin, cout);

end Structural;
