----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2025 07:35:24
-- Design Name: 
-- Module Name: mainCtrlUnit - Behavioral
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



entity mainCtrlUnit is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           controlSignals : out STD_LOGIC_VECTOR (15 downto 0));
end mainCtrlUnit;

architecture Behavioral of mainCtrlUnit is

signal currentState, nextState: std_logic_vector (4 downto 0);
--- 00000: Reset
--- 00000: Fetch
--- 00001: Decode
--- 00010: MemAddress

signal counter, nextCounter: std_logic_vector (31 downto 0);
signal i_clock: std_logic;
signal clk_1Hz: std_logic;
begin
    freqDiv: process (reset, clock)
        begin
            if (reset ='1') then
                counter <= x"00000000";
            elsif (clock'event and clock = '1') then
                counter <= nextCounter;
            end if;
        end process;
        
        nextCounter <= counter + 1;
        i_clock <= counter (20);
    
    nextStateFunction: process (opcode, currentState)
    begin
        case (currentState) is
          when "00000" => --Reset
             nextstate <= "00001";
          when "00001" => --fetch
             nextstate <= "00010";
          when "00010" => --decode
             if (opcode = "100011" or opcode ="101101") then
                nextState <= "00011"; -- go to memAddress
             elsif (opcode = "00000") then
                nextState <= "00111"; --go to Execute
             elsif (opcode = "00100") then
                nextState <= "01001"; 
             elsif (opcode = "00010") then
                nextState <= "01010"; 
             else
                nextState <= "00000";
             end if;
                
          when "00011" => --memAddress
            if (opcode = "100011") then
                nextState <= "00100";
            else
                nextState <= "00110";
            end if;
          when "00100" => --memRead
             nextstate <= "00101";
          when "00101" => --memWriteback
             nextstate <= "00001";
          when "00110" => --memWrite
             nextstate <= "00001";
          when "00111" => --excecute
             nextstate <= "01000";
          when "01000" => -- ALU writeBack
             nextstate <= "00001";
          when "01001" => --beq
             nextstate <= "00001";
          when "01010" => --jump
             nextstate <= "00001";
          when others =>
             nextstate <= "00000";
       end case;
        end process;
    
    stateRegister: process (reset, i_clock)
    begin
        if (reset = '1') then
            currentState <= "00000";
        elsif (i_clock'event and i_clock ='1') then 
            currentState <= nextState;
        end if;
    end process;
    
    outputFunction: process (currentState)
    begin
        case (currentState) is
          when "00000" => --reset
             controlSignals <= "0000000000000000";
          when "00001" => --fetch
             controlSignals <= "0001000000101001";
          when "00010" => --decode
             controlSignals <= "0011000000000000"; 
          when "00011" => --memAddress
             controlSignals <= "0110000000000000";
          when "00100" => --memRead
             controlSignals <= "0000000000011000";
          when "00101" => --memWriteback
             controlSignals <= "1000000000000010";
          when "00110" => --memWrite
             controlSignals <= "0000000000010100";
          when "00111" => --excecute
             controlSignals <= "0100010000000000";
          when "01000" => -- ALU writeBack
             controlSignals <= "1000000000000000";
          when "01001" => --beq
             controlSignals <= "0100001011000000";
          when "01010" => --jump
             controlSignals <= "0000000100100000";
          when others =>
             controlSignals <= "0000000000000000";
       end case;
    end process;

end Behavioral;
