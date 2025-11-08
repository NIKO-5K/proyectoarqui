----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.09.2025 08:00:29
-- Design Name: 
-- Module Name: MIPSprocesador - Behavioral
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



entity MIPSprocesador is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           address : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           read : out STD_LOGIC;
           write : out STD_LOGIC);
end MIPSprocesador;


architecture Behavioral of MIPSprocesador is
component register32b
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           enable : in STD_LOGIC);
end component;

component alu_32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           result, result2 : out STD_LOGIC_VECTOR (31 downto 0);
           zeroFlag : out STD_LOGIC);
end component;

component mux2a1_32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           Mout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux4a1_32bits
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           Mout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux4a1_5bits
    Port ( A : in STD_LOGIC_VECTOR (4 downto 0);
           B : in STD_LOGIC_VECTOR (4 downto 0);
           C : in STD_LOGIC_VECTOR (4 downto 0);
           D : in STD_LOGIC_VECTOR (4 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           Mout : out STD_LOGIC_VECTOR (4 downto 0));
end component;


component register_file
    Port ( clock : in STD_LOGIC;
           address1 : in STD_LOGIC_VECTOR (4 downto 0);
           address2 : in STD_LOGIC_VECTOR (4 downto 0);
           address3 : in STD_LOGIC_VECTOR (4 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut1 : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut2 : out STD_LOGIC_VECTOR (31 downto 0);
           write : in STD_LOGIC);
end component;

component ALU_ctrl is
    Port ( funct_in : in STD_LOGIC_VECTOR (5 downto 0);
           aluOp : in STD_LOGIC_VECTOR (2 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end component;



signal inPC, outPC, outIR, outALURout, outMDR, dataInRF, inA, inB, outA, outB, extData, inAluA, inAluB, outALU, addressJump: std_logic_vector (31 downto 0);
signal enablePC, iOrD, enableIR, regWrite, aluSrcA, memToReg, iZeroFlag,notClock : std_logic;
signal regDst, aluSrcB, pcSrc: std_logic_vector (1 downto 0);
signal addr3RF : std_logic_vector (4 downto 0);
signal operationALU: std_logic_vector (3 downto 0);
signal aluOp: std_logic_vector (2 downto 0);
signal controlUnitSignals : std_logic_vector (17 downto 0);

begin

    notClock <= not clock;

    PC : register32b
    port map (
        reset => reset,
        clock => notClock,
        dataIn => InPC,
        dataOut => OutPC,
        enable => enablePC
    );
    
    addrOut: mux2a1_32b
    port map(
        A => outPC,
        B => outALURout,
        sel => iOrD,
        Mout => address
    );
    
    IR: register32b
    port map (
        reset => reset,
        clock => notClock,
        dataIn => dataIn,
        dataOut => outIR,
        enable => enableIR
    );
    
    MDR: register32b
    port map (
        reset => reset,
        clock => notClock,
        dataIn => dataIn,
        dataOut => outMDR,
        enable => '1'
    );
    
    rfAddr: mux4a1_5bits
    port map (
        A => outIR(20 downto 16),
        B => outIR(15 downto 11),
        C => "11111",
        D => "11111",
        sel => regDst,
        Mout => addr3RF
    );
    
    MDRmux: mux2a1_32b
    port map(
        A => outMDR,
        B => outALURout,
        sel => memToReg,
        Mout => datainRF
    );   
  
    RF: register_file
    port map (
        clock => notClock,
        address1 => outIR(25 downto 21),
        address2 => outIR(20 downto 16),
        address3 => addr3RF,
        dataIn => dataInRF,
        dataOut1 => inA,
        dataOut2 => inB,
        write => regWrite
    );
    
    signExtend: process (outIR (15 downto 0))
    begin
        if(outIR(15) = '1') then
            extData <= x"FFFF" & outIR(15 downto 0);
        else
            extData <= x"0000" & outIR(15 downto 0);
        end if;
    end process;
    
    regA: register32b
    port map (
        reset => reset,
        clock => notClock,
        enable => '1',
        dataIn => inA,
        dataOut => outA
    );
    
    regB: register32b
    port map (
        reset => reset,
        clock => notClock,
        enable => '1',
        dataIn => inB,
        dataOut => outB
    );
    
   inAmux: mux2a1_32b
    port map(
        A => outPC,
        B => outA,
        sel => aluSrcA,
        Mout => inAluA
    );  
 
   inBmux: mux4a1_32bits
    port map(
        A => outB,
        B => x"00000001",
        C => extData,
        D => extData,
        sel => aluSrcB,
        Mout => inAluB
    );  
    ALU: alu_32b
     port map(
        A => inAluA,
        B => inAluB,
        operation => operationALU,
        result => outALU,
        zeroFlag => iZeroFlag
    );
    controlALU: ALU_ctrl
    port map(
        aluOp => aluOp,
        funct_in => outIR (5 downto 0),
        operation => operationALU
    );
    aluOutReg: register32b
    port map (
        reset => reset,
        clock => notClock,
        enable => '1',
        dataIn => outALU,
        dataOut => outALURout
    );
    
    addressJump <= "000000" & outIR(25 downto 0);
    PCmux: mux4a1_32bits 
    port map(
        A => outALU,
        B => outALURout,
        C => addressJump,
        D => addressJump,
        sel => pcSrc,
        Mout => inPC
    );     
end Behavioral;