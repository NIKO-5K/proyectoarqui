----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.09.2025 07:50:46
-- Design Name: 
-- Module Name: MIPScomputer - Behavioral
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

entity MIPScomputer is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           dataOut : out STD_LOGIC_VECTOR (15 downto 0));
end MIPScomputer;

architecture Behavioral of MIPScomputer is
component MIPSprocesador
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           address : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           read : out STD_LOGIC;
           write : out STD_LOGIC);
end component;
component mux2a1_32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           Mout : out STD_LOGIC_VECTOR (31 downto 0));
end component;
component register32b
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           enable : in STD_LOGIC);
end component;

component MIPSmemory
    Port ( clock : in STD_LOGIC;
   
           write, read: in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (10 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));

end component;
signal dataMtoP, addressPtoM, dataPtoM,dataIn_32b,dataMux2P,dataOutExt: std_logic_vector (31 downto 0);
signal readPtoM, writePtoM,outputEnable,writeMemory: std_logic;
begin
    U0: MIPSprocesador
    port map (
    reset => reset,
    clock => clock,
    dataIn => dataMux2P,
    address => addressPtoM,
    dataOut => dataPtoM,
    read => readPtoM,
    write => writePtoM
    );
    
    U1: MIPSmemory
    port map (
    clock => clock,
    address => addressPtoM (10 downto 0),
    dataIn => dataPtoM,
    dataOut => dataMtoP,
    read => readPtoM,
    write => writeMemory
    );
    writeMemory <= writePtoM and not (addressPtoM(12));
    dataIn_32b <= x"0000" & dataIn;
    inMux: mux2a1_32b
    port map(
        A => dataMtoP,
        B => dataIn_32b,
        sel => addressPtoM(12),
        Mout => dataMux2P
    );
    outReg: register32b
    port map(
    reset => reset,
    clock => clock,
    enable => outputEnable,
    dataIn => dataPtoM,
    dataOut => dataOutExt
    );
    outputEnable <= writePtoM and addressPtoM(12);
    dataOut <= dataOutExt(15 downto 0);
end Behavioral;
