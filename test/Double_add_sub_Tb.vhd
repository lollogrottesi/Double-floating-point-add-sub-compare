----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.08.2020 14:59:23
-- Design Name: 
-- Module Name: Double_add_sub_Tb - Behavioral
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

entity Double_add_sub_Tb is
--  Port ( );
end Double_add_sub_Tb;

architecture Behavioral of Double_add_sub_Tb is
component Double_add_sub is
    port (FP_a: in std_logic_vector(63 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(63 downto 0);
          add_sub: in std_logic;
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic;
          FP_z: out std_logic_vector(63 downto 0));
end component;

component Double_cmp_add_sub is
    port (FP_a: in std_logic_vector(63 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(63 downto 0);
          add_subAndCmp: in std_logic;
          cmp_ctrl:      in std_logic_vector(2 downto 0);   --Select one compare operation.
          cmp_out:       out std_logic;                     --Result of the selected comparison.
          FP_z: out std_logic_vector(63 downto 0));
end component;

signal a, b, z :std_logic_vector(63 downto 0);
signal a_s, cmp_out: std_logic;
signal cmp_ctrl: std_logic_vector(2 downto 0);
begin
dut : Double_cmp_add_sub port map (a, b, a_s, cmp_ctrl, cmp_out, z);



    process
    begin
        cmp_ctrl <= "000";
        a_s <= '0';
        a <= x"3FF3333333333333";
        b <= x"BFF8000000000000";
        wait for 10 ns;
        a <= x"4049000000000000";
        b <= x"4049000000000000";
        wait for 10 ns;
        a <= x"C011C28F5C28F5C3";
        b <= x"4008F5C28F5C28F6";
        wait for 10 ns;
        a <= x"C0187AE147AE147B";
        b <= x"C015333333333333";
        wait for 10 ns;
        
        a_s <= '1';
        a <= x"3FF0000000000000";
        b <= x"3FF0000000000000";
        wait for 10 ns;
        cmp_ctrl <= "001";
        a <= x"3FF3333333333333";
        b <= x"BFF8000000000000";
        wait for 10 ns;
        cmp_ctrl <= "011";
        a <= x"4049000000000000";
        b <= x"4049000000000000";
        wait for 10 ns;
        a <= x"C011C28F5C28F5C3";
        b <= x"4008F5C28F5C28F6";
        wait for 10 ns;
        b <= x"C0187AE147AE147B";
        a <= x"C015333333333333";
        wait;
    end process;


end Behavioral;
