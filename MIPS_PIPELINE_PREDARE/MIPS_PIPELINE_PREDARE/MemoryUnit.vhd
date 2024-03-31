----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 06:47:35 PM
-- Design Name: 
-- Module Name: MemoryUnit - Behavioral
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

entity MemoryUnit is
    port(ALUResI,RD2:in std_logic_vector(15 downto 0);
        clk,buton,MemWrite:in std_logic;
        ALUResO,MemData:out std_logic_vector(15 downto 0));
end MemoryUnit;

architecture Behavioral of MemoryUnit is
type MEMORIE is array (0 to 3) of std_logic_vector(15 downto 0);
signal M :MEMORIE:=(X"0011",X"0006",X"0044",X"0004");       --(X"0006",X"0011",X"0044",X"0004");    --(X"0011",X"0006",X"0044",X"0004");
begin
process(clk,MemWrite)
begin
    if rising_edge(clk) then
        if MemWrite='1' then 
            if buton='1' then
                 M(conv_integer(ALUResI(1 downto 0)))<=RD2;
             end if;
        end if;
   end if;
end process;
MemData<=M(conv_integer(ALUResI(1 downto 0)));
ALUResO<=ALUResI;
end Behavioral;
