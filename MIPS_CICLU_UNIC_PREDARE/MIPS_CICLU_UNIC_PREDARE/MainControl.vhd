----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2023 07:14:23 PM
-- Design Name: 
-- Module Name: MainControl - Behavioral
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

entity MainControl is
     port(opcode,func:in std_logic_vector(2 downto 0);
           RegDest,RegW,ExtOp,AluSrc,MemW,MemtoReg,Branch,Jump,bgt:out std_logic;
           AluCtrl:out std_logic_vector(2 downto 0));
end MainControl;

architecture Behavioral of MainControl is

begin
process(opcode,func)
begin
    case opcode is
    when"000"=> RegDest <= '1';
            RegW <= '1';
            ExtOp <= 'X';
            AluSrc <= '0';
            AluCtrl <= func;
            MemW <= '0';
            MemtoReg <= '0';
            Branch <= '0';
            Jump <= '0';
            bgt <= '0';
    when"001"=> RegDest <= '0';
            RegW <= '1';
            ExtOp <= '1';
            AluSrc <= '1';
            AluCtrl <= "000";
            MemW <= '0';
            MemtoReg <= '0';
            Branch <= '0';
            Jump <= '0';
            bgt <= '0';
    when"010"=> RegDest <= '0';
            RegW <= '1';
            ExtOp <= '1';
            AluSrc <= '1';
            AluCtrl <= "000";
            MemW <= '0';
            MemtoReg <= '1';
            Branch <= '0';
            Jump <= '0';
            bgt <= '0';
    when"011"=> RegDest <= 'X';
            RegW <= '0';
            ExtOp <= '1';
            AluSrc <= '1';
            AluCtrl <= "000";
            MemW <= '1';
            MemtoReg <= '0';
            Branch <= '0';
            Jump <= '0';
            bgt <= '0';
    when"100"=> RegDest <= 'X';
            RegW <= '0';
            ExtOp <= '1';
            AluSrc <= '0';
            AluCtrl <= "001";
            MemW <= '0';
            MemtoReg <= 'X';
            Branch <= '1';
            Jump <= '0';
            bgt <= '0';
    when"101"=> RegDest <= 'X';
            RegW <= '0';
            ExtOp <= '1';
            AluSrc <= '0';
            AluCtrl <= "001";
            MemW <= '0';
            MemtoReg <= 'X';
            Branch <= '0';
            Jump <= '0';
            bgt <= '1';
    when"110"=> RegDest <= '0';
            RegW <= '1';
            ExtOp <= '1';
            AluSrc <= '1';
            AluCtrl <= "100";
            MemW <= '0';
            MemtoReg <= '0';
            Branch <= '0';
            Jump <= '0';
            bgt <= '0';
    when others=> RegDest <= 'X';
            RegW <= '0';
            ExtOp <= 'X';
            AluSrc <= 'X';
            AluCtrl <= "XXX";
            MemW <= '0';            --'0';      --'X';
            MemtoReg <= 'X';
            Branch <= 'X';
            Jump <= '1';
            bgt <= 'X';
    end case;
end process;

end Behavioral;
