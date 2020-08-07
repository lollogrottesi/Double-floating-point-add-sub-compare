----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.08.2020 16:30:44
-- Design Name: 
-- Module Name: Double_cmp_add_sub - Structural
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

entity Double_cmp_add_sub is
    port (FP_a: in std_logic_vector(63 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(63 downto 0);
          add_subAndCmp: in std_logic;
          cmp_ctrl:      in std_logic_vector(2 downto 0);   --Select one compare operation.
          cmp_out:       out std_logic;                     --Result of the selected comparison.
          FP_z: out std_logic_vector(63 downto 0));
end Double_cmp_add_sub;

architecture Structural of Double_cmp_add_sub is

component Double_add_sub is
    port (FP_a: in std_logic_vector(63 downto 0);--Normalized  biased values.
          FP_b: in std_logic_vector(63 downto 0);
          add_sub: in std_logic;
          overflow: out std_logic;
          underflow: out std_logic;
          OMZ: out std_logic;
          FP_z: out std_logic_vector(63 downto 0));
end component;

signal overflow,underflow, OMZ: std_logic;
signal A_eq_B, A_not_eq_B, A_gr_eq_B, A_gr_B, A_low_eq_B, A_low_B: std_logic;
signal sign_a_b: std_logic_vector(1 downto 0);
begin
--If SUB selected OMZ out flags A_eq_B.
FP_add_sub_unit: Double_add_sub port map (FP_a, FP_b, add_subAndCmp, overflow, underflow, OMZ, FP_z);
sign_a_b <= FP_a(63)&FP_b(63);

process(sign_a_b, overflow, OMZ, FP_a, FP_B)
    begin
        case sign_a_b is
            when "00"=>
                A_eq_B <= OMZ;
                A_gr_eq_B <= overflow;
                A_not_eq_B <= not A_eq_B;
                A_gr_B <= overflow and (not OMZ);
                A_low_B <= not overflow;
                A_low_eq_B <= not overflow or OMZ;
            when "01" =>
                --A > B.
                A_eq_B <= '0';
                A_not_eq_B <= '1';
                A_gr_eq_B <= '1';
                A_gr_B <= '1';
                A_low_B <= '0';
                A_low_eq_B <= '0';
            when "10" =>
                --A < B.
                A_eq_B <= '0';
                A_not_eq_B <= '1';
                A_gr_eq_B <= '0';
                A_gr_B <= '0';
                A_low_B <= '1';
                A_low_eq_B <= '1';
            when "11" =>
                A_eq_B <= OMZ;
                A_gr_eq_B <= overflow;
                A_not_eq_B <= not A_eq_B;
                A_gr_B <= overflow and (not OMZ);
                A_low_B <= not overflow;
                A_low_eq_B <= not overflow or OMZ;
            when others=> 
                A_eq_B <= OMZ;
                A_gr_eq_B <= overflow;
                A_not_eq_B <= not A_eq_B;
                A_gr_B <= overflow and (not OMZ);
                A_low_B <= not overflow;
                A_low_eq_B <= not overflow or OMZ;
        end case; 
    end process;
    
cmp_out <= A_eq_B       when cmp_ctrl = "000" else
           A_not_eq_B   when cmp_ctrl = "001" else
           A_gr_eq_B    when cmp_ctrl = "010" else
           A_gr_B       when cmp_ctrl = "011" else
           A_low_eq_B   when cmp_ctrl = "100" else
           A_low_B      when cmp_ctrl = "101" else
           '0';
end Structural;
