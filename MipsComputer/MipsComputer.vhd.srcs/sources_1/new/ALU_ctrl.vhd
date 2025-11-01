----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 07:43:38
-- Design Name: 
-- Module Name: ALU_ctrl - Behavioral
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


entity ALU_ctrl is
    Port ( funct_in : in STD_LOGIC_VECTOR (5 downto 0);
           aluOp : in STD_LOGIC_VECTOR (2 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end ALU_ctrl;

architecture Behavioral of ALU_ctrl is

begin
process (funct_in, aluOP)
begin

   case (aluOP) is
      when "000" =>
         operation <= "0010";
      when "001" =>
         operation <= "0110";
      when "010" =>
         case (funct_in) is 
            when "100000" => operation <= "0010";
            when "100010" => operation <= "0110";
            when "100100" => operation <= "0000";
            when "100101" => operation <= "0001";
            when "101010" => operation <= "0111";
            when others => operation <= "0010";
         end case;
         
      when "011" => --addi
         operation <= "0010";
      when "100" => --ori
         operation <= "0001";
      when others =>
         operation <= "0010";
   end case;
end process;
end Behavioral;
