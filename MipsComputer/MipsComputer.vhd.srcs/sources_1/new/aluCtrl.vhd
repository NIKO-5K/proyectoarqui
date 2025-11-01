----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 07:29:19
-- Design Name: 
-- Module Name: aluCtrl - Behavioral
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

entity aluCtrl is
    Port ( funct_in : in STD_LOGIC_VECTOR (5 downto 0);
           aluOp : in STD_LOGIC_VECTOR (2 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end aluCtrl;

architecture Behavioral of aluCtrl is
signal tempF : std_logic_vector (3 downto 0);
begin
     with aluOp select
        operation <= "0010" when "000",
                     "0110" when "001",
                     tempF  when "010",
                     "0010" when others;
                     
     with funct_in select
        tempF <= "0010" when "100000",
                 "0110" when "100010",
                 "0000" when "100100",
                 "0001" when "100101",
                 "0111" when "101010",
                 "0010" when others;
end Behavioral;
