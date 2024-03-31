----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 06:17:01 PM
-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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

entity ExecutionUnit is
    port(PCPLUS1,RD1,RD2,EXT_IMM:in std_logic_vector(15 downto 0);
        sa,ALUSrc:in std_logic;
        func,ALUCtrl:in std_logic_vector(2 downto 0);
        zero,maiMare:out std_logic;
        ALURes,BranchAdress:out std_logic_vector(15 downto 0));
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal B: std_logic_vector(15 downto 0);
signal INTERMEDIAR:std_logic_vector(15 downto 0);

begin

MUX:process(ALUSrc,RD2,EXT_IMM)
    begin
    if ALUSrc='1' then
        B<=EXT_IMM;
     else
        B<=RD2;
     end if;
    end process;

DET_ALUCtrl:process(func,ALUCtrl,RD1,B,sa,INTERMEDIAR)
            begin
                case(ALUCtrl) is
                when "000"=>INTERMEDIAR<=RD1+B;
                when "001"=>INTERMEDIAR<=RD1-B;
                when "010"=>if sa='1' then 
                                INTERMEDIAR<=RD1(14 downto 0) & '0';
                           else
                             INTERMEDIAR<=RD1;
                            end if;
                when "011"=>if sa='1' then 
                                INTERMEDIAR<='0' & RD1(15 downto 1) ;
                           else
                             INTERMEDIAR<=RD1;
                            end if;
                when "100"=>INTERMEDIAR<=RD1 and B;
                when "101"=>INTERMEDIAR<=RD1 or B;
                when "110"=> INTERMEDIAR<=RD1 xor B;
                when "111"=>INTERMEDIAR<=not(RD1 xor B);
                end case;
            end process;
ALURes<=INTERMEDIAR;
zero<='1' when INTERMEDIAR=x"0000" else '0';
maiMare<='1' when INTERMEDIAR(15)='0' else '0';
--maiMare<='1' when INTERMEDIAR>x"0000" else '0';
--maiMare<='1' when conv_integer(INTERMEDIAR)>0 else '0';
BranchAdress<=PCPlus1+EXT_IMM;
--BranchAdress<=EXT_IMM;
end Behavioral;
