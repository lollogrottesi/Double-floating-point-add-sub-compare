----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 09:31:45
-- Design Name: 
-- Module Name: Carry_look_ahead - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY c_l_addr IS
    generic (N: integer:= 25);
    PORT
        (
         x_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
END c_l_addr;

ARCHITECTURE behavioral OF c_l_addr IS

SIGNAL    h_sum              :    STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL    carry_generate     :    STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL    carry_propagate    :    STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL    carry_in_internal  :    STD_LOGIC_VECTOR(N-1 DOWNTO 1);

BEGIN
    h_sum <= x_in XOR y_in;
    carry_generate <= x_in AND y_in;
    carry_propagate <= x_in OR y_in;
    carry_in_internal(1) <= carry_generate(0) OR (carry_propagate(0) AND carry_in);
        inst: FOR i IN 1 TO N-2 generate
              carry_in_internal(i+1) <= carry_generate(i) OR (carry_propagate(i) AND carry_in_internal(i));
              END generate;
    carry_out <= carry_generate(N-1) OR (carry_propagate(N-1) AND carry_in_internal(N-1));

    sum(0) <= h_sum(0) XOR carry_in;
    sum(N-1 DOWNTO 1) <= h_sum(N-1 DOWNTO 1) XOR carry_in_internal(N-1 DOWNTO 1);
END behavioral;
