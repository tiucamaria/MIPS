----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 11:40:39 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Fetch is
    Port (clk:in std_logic;
          branch:in std_logic_vector(15 downto 0);
          jumpA:in std_logic_vector(15 downto 0);
          jump:in std_logic;
          PCSrc:in std_logic;
          en:in std_logic;
          Instruction:out std_logic_vector(15 downto 0);
          PC1:out std_logic_vector(15 downto 0));
end entity;

architecture Behavioral of Instruction_Fetch is

type MEMORIE is array (0 to 45) of std_logic_vector(15 downto 0);
signal M:MEMORIE:=(x"4080",x"4101",x"0030",x"0040",
                    x"A51B",x"0000",x"0000",x"0000",
                    x"851F",x"0000",x"0000",x"0000",
                    x"C707",x"0000",x"0000",
                    x"9808",x"0000",x"0000",x"0000",
                    x"E008",x"2481",x"0000",x"0000",x"0000",
                    x"10C0",x"2D81",
                    x"E008",x"2481",x"0000",x"0000",x"0000",x"0000",
                    x"0050",x"0450",
                    x"0810",x"E008",x"1420",x"0000",x"0000",x"0000",x"6202", x"6183",
                    x"0000",x"0000",x"0000",x"0000"); --PRIMELE2/ULTIMELE 2 MODIFICAT CITIT a,b, SCRIS s,nr
signal inPC:std_logic_vector(15 downto 0);
signal outPC:std_logic_vector(15 downto 0);
signal mux1out:std_logic_vector(15 downto 0);

begin
    MuxPCSrc:process(PCSrc,mux1out,branch,outPC)
    begin
    if PCSrc='1' then 
        mux1out<=branch;
    else 
        mux1out<=outPC+1;
    end if;
    end process;
        
MuxJump:process(jump,inPC,jumpA,mux1out)
    begin
    if jump='1' then 
        inPC<=jumpA;
    else 
        inPC<=mux1out;
    end if;
    end process;

    PC:process(clk,inPC,en,outPC)
    begin
    if rising_edge(clk) then 
        if en='1' then 
            outPC<=inPC;
         end if;
    end if;
    end process;

PC1<=outPC+1;
Instruction<=M(conv_integer(outPC));

end Behavioral;
