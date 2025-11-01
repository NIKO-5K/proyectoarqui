----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 07:41:19
-- Design Name: 
-- Module Name: register_file - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_file is
    Port ( clock : in STD_LOGIC;
           address1 : in STD_LOGIC_VECTOR (4 downto 0);
           address2 : in STD_LOGIC_VECTOR (4 downto 0);
           address3 : in STD_LOGIC_VECTOR (4 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut1 : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut2 : out STD_LOGIC_VECTOR (31 downto 0);
           write : in STD_LOGIC);
end register_file;

architecture Behavioral of register_file is
    type memType is array (0 to 31) of std_logic_vector (31 downto 0);
    signal regMemory : memType;

begin

    process (clock)
    begin
        if (clock'event and clock='1' and write = '1') then
            regMemory (conv_integer(address3)) <= dataIn;
        end if;
    end process;
    dataOut1 <= regMemory (conv_integer (address1));    
    dataOut2 <= regMemory (conv_integer (address2));
end Behavioral;