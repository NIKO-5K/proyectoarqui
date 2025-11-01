----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2025 07:51:47
-- Design Name: 
-- Module Name: alu_32b - Behavioral
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
use IEEE.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           result2 : out STD_LOGIC_VECTOR (31 downto 0);
           zeroFlag : out STD_LOGIC);
end alu_32b;

architecture Behavioral of alu_32b is
signal temp1, temp2,temp3, temp4, temp5, tempResult : std_logic_vector (31 downto 0);
signal temp6 : std_logic_vector (63 downto 0);
begin

    temp1 <= A and B;
    temp2 <= A or B;
    temp3 <= A + B;
    temp4 <= A - B;
    temp5 <= x"00000001" when A < B else
             x"00000000";
    temp6 <= A * B;
    
    with operation select
        tempResult <= temp1 when "0000",
                  temp2 when "0001",
                  temp3 when "0010",
                  temp4 when "0110",
                  temp5 when "0111",
                  temp6 (31 downto 0) when "1111",
                  A when others;
                  
    zeroFlag <= '1' when tempResult = x"00000000" else
                '0';
    result2 <= temp6(63 downto 32);
    result <= tempResult;

end Behavioral;