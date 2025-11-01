----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.09.2025 08:03:41
-- Design Name: 
-- Module Name: MIPSmemory - Behavioral
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


entity MIPSmemory is
    Port ( clock : in STD_LOGIC;
           
           write, read : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (10 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end MIPSmemory;

architecture Behavioral of MIPSmemory is
 type memory_type is array (0 to 2047) of std_logic_vector (31 downto 0);
 signal myMemory: memory_type :=(x"00000000",x"00000001",others =>(others =>x"00000000");
begin
    process (clock)
    begin
        if (clock'event and clock ='1') then
            if (write = '1') then
                myMemory (conv_integer (address)) <= dataIn;
            end if;
        end if;  
    end process;
    dataOut <= myMemory (conv_integer (address) );

end Behavioral;
