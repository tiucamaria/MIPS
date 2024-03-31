----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2023 06:22:01 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
Port(digit:in std_logic_vector(15 downto 0);
    clk:in std_logic;
    an: out std_logic_vector(3 downto 0);
    cat:out std_logic_vector(6 downto 0));
end SSD;

architecture Behavioral of SSD is
signal count_int:std_logic_vector(15 downto 0);
signal hex:std_logic_vector(3 downto 0);
begin

   COUNT:process(clk)
    begin
        if rising_edge(clk) then
            count_int<=count_int + 1;
        end if;
    end process;

   MUX_ANOD:process(count_int(15 downto 14))
        begin 
        case count_int(15 downto 14) is
            when "00"=>an<="1110";
            when "01"=>an<="1101";
            when "10"=>an<="1011";
            when others=>an<="0111";
        end case;
    end process;
    
    MUX_HEX:process(count_int(15 downto 14))
        begin 
        case count_int(15 downto 14) is
            when "00"=>hex<=digit(3 downto 0);
            when "01"=>hex<=digit(7 downto 4);
            when "10"=>hex<=digit(11 downto 8);
            when others=>hex<=digit(15 downto 12);
        end case;
    end process;

with hex SELect
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

end Behavioral;
