----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2023 06:14:28 PM
-- Design Name: 
-- Module Name: InstrDecode - Behavioral
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

entity InstrDecode is
    port(clk,buton:in std_logic;
        RegWr,RegDst,ExtOp:in std_logic;
        instr,WD:in std_logic_vector(15 downto 0);
        RD1,RD2,Ext_Imm:out std_logic_vector(15 downto 0);
        func:out std_logic_vector(2 downto 0);
        sa:out std_logic);    
end entity;

architecture Behavioral of InstrDecode is

component reg_file
    port (
        clk : in std_logic;
        buton : in std_logic;
        ra1 : in std_logic_vector (2 downto 0);
        ra2 : in std_logic_vector (2 downto 0);
        wa : in std_logic_vector (2 downto 0);
        wd : in std_logic_vector (15 downto 0);
        RegWr: in std_logic;
        rd1 : out std_logic_vector (15 downto 0);
        rd2 : out std_logic_vector (15 downto 0));
end component;

signal WA:std_logic_vector(2 downto 0);

begin
Reg: reg_file port map(clk,buton, instr(12 downto 10),instr(9 downto 7),WA,WD,RegWr,RD1,RD2);

MUX_WA:process(RegDst,instr(9 downto 7), instr(6 downto 4))
        begin
        if RegDst='0' then
            WA<=instr(9 downto 7);
        else 
            WA<=instr(6 downto 4);
        end if;
        end process;

Extindere:process(ExtOp, instr(6 downto 0))
            begin
                if ExtOp='0' or instr(6)='0' then
                    Ext_Imm<="000000000"&instr(6 downto 0);
                else
                    Ext_Imm<="111111111"&instr(6 downto 0);
                end if;
            end process;
            
INSTR_R:process(instr)
        begin
            if instr(15 downto 13)="000" then
                func<=instr(2 downto 0);
                sa<=instr(3);
            else
                sa<='0';
            end if;
        end process;
end Behavioral;
