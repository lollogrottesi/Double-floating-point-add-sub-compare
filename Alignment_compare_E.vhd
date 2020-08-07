----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2020 14:27:05
-- Design Name: 
-- Module Name: Alignment_compare_E - Mixed
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

entity Alignment_compare_E is
    port (E_a: in std_logic_vector(10 downto 0); --E is supposed to be biased.
          E_b: in std_logic_vector(10 downto 0);
          shift_M_a: out std_logic_vector(10 downto 0);
          shift_M_b: out std_logic_vector(10 downto 0);
          max_E: out std_logic_vector(10 downto 0));
end Alignment_compare_E;

architecture Mixed of Alignment_compare_E is

component Comparator is
    Generic (N: integer:= 32);
    Port (A: in std_logic_vector (N-1 downto 0);
          B: in std_logic_vector (N-1 downto 0);
          A_eq_B: out std_logic;
          A_gr_B: out std_logic;
          A_low_B: out std_logic); 
end component;

signal Ea_eq_Eb, Ea_gr_Eb, Ea_low_Eb: std_logic;
--signal diff: std_logic_vector(7 downto 0);
begin
comapare_exponent: Comparator generic map (11)   --The comparator works only for unisgned numbers, so input E must be biased.
                              port map(E_a, E_b, Ea_eq_Eb, Ea_gr_Eb, Ea_low_Eb);
                              
    --Using the comparator output decide wich Exponent is max and the shift amount for the next stage.                              
    process(E_a, E_b, Ea_eq_Eb, Ea_gr_Eb, Ea_low_Eb)                              
    begin
        if (Ea_eq_Eb = '1') then
            max_E <= std_logic_vector(unsigned(E_a)); 
            shift_M_a <= (others => '0');
            shift_M_b <= (others => '0');
        elsif (Ea_gr_Eb = '1') then
            max_E <= E_a;
            shift_M_b <= std_logic_vector(unsigned (E_a) - unsigned(E_b));
            shift_M_a <= (others => '0');
        elsif (Ea_low_Eb = '1') then
            max_E <= E_b;
            shift_M_a <= std_logic_vector(unsigned (E_b) - unsigned(E_a));
            shift_M_b <= (others => '0');
        end if;
    end process;
    
                             
end Mixed;
