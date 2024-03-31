----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2023 10:45:14 PM
-- Design Name: 
-- Module Name: saqwdf - Behavioral
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

entity principal is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end entity;

architecture Behavioral of principal is

component MPG 
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component Instruction_Fetch 
    Port (clk:in std_logic;
          branch:in std_logic_vector(15 downto 0);
          jumpA:in std_logic_vector(15 downto 0);
          jump:in std_logic;
          PCSrc:in std_logic;
          en:in std_logic;
          Instruction:out std_logic_vector(15 downto 0);
          PC1:out std_logic_vector(15 downto 0));
end component;

component InstrDecode 
    port(clk:in std_logic;
         buton : in std_logic;
        RegWr,RegDst,ExtOp:in std_logic;
        instr,WD:in std_logic_vector(15 downto 0);
        RD1,RD2,Ext_Imm:out std_logic_vector(15 downto 0);
        func:out std_logic_vector(2 downto 0);
        sa:out std_logic);    
end component;

component SSD 
Port(digit:in std_logic_vector(15 downto 0);
    clk:in std_logic;
    an: out std_logic_vector(3 downto 0);
    cat:out std_logic_vector(6 downto 0));
end component;

component MainControl 
     port(opcode,func:in std_logic_vector(2 downto 0);
           RegDest,RegW,ExtOp,AluSrc,MemW,MemtoReg,Branch,Jump,bgt:out std_logic;
           AluCtrl:out std_logic_vector(2 downto 0));
enD component;

component MemoryUnit
    port(ALUResI,RD2:in std_logic_vector(15 downto 0);
        clk,buton,MemWrite:in std_logic;
        ALUResO,MemData:out std_logic_vector(15 downto 0));
end component;

component ExecutionUnit 
    port(PCPLUS1,RD1,RD2,EXT_IMM:in std_logic_vector(15 downto 0);
        sa,ALUSrc:in std_logic;
        func,ALUCtrl:in std_logic_vector(2 downto 0);
        zero,maiMare:out std_logic;
        ALURes,BranchAdress:out std_logic_vector(15 downto 0));
end component;

signal btn_nou:std_logic;
signal instr:std_logic_vector(15 downto 0);
signal pc:std_logic_vector(15 downto 0);
signal afis:std_logic_vector(15 downto 0);

signal RegDest,RegW,ExtOp,AluSrc,MemW,MemtoReg,Branch,Jump,bgt:std_logic;
signal AluCtrl:std_logic_vector(2 downto 0);

signal WD,RD1,RD2,Ext_Imm:std_logic_vector(15 downto 0);
signal func:std_logic_vector(2 downto 0);
signal sa:std_logic;

signal zero,maiMare:std_logic;
signal ALURes,BranchAdress,MemData:std_logic_vector(15 downto 0);
signal MemWrite:std_logic;

signal PCSrc:std_logic;
signal JumpAdress,ALUResO:std_logic_vector(15 downto 0);

begin
    WEN: MPG port map(btn_nou,btn(0),clk);
    InF:Instruction_Fetch port map(clk,BranchAdress,JumpAdress,Jump,PCSrc,btn_nou,instr,pc); 
    Afisor:SSD port map(afis,clk,an,cat);
    Control:MainControl port map(instr(15 downto 13),func, RegDest,RegW,ExtOp,AluSrc,MemW,MemtoReg,Branch,Jump,bgt,AluCtrl);
    InD:InstrDecode port map(clk,btn_nou,RegW,RegDest,ExtOp,instr,WD,RD1,RD2,Ext_Imm,func,sa); 
    ALU:ExecutionUnit port map(pc,RD1,RD2,Ext_Imm,sa,ALUSrc,func,ALUCtrl,zero,maiMare,ALURes,BranchAdress);
    MemoryRAM:MemoryUnit port map(ALURes,RD2,clk,btn_nou,MemWrite,ALUResO,MemData);            
        
 --led afisat din indrumator lab   
 led(2 downto 0)<=instr(15 downto 13); --afisat pe led pt verificare
 --led(5 downto 3)<=func;         --afisat pe led pentru verificare
 led(5 downto 3)<=ALUCtrl;
 led(6)<=sa;
 
 led(15)<=jump;
 led(14)<=Branch;
 led(13)<=bgt;
 
 led(12)<=MemtoReg;
 led(11)<=MemW;
 led(10)<=RegW;
 led(9)<=RegDest;
 led(8)<=ExtOp;
 led(7)<=AluSrc;
 
 --SI LA SALT + BGT
 PCSrc<=(zero and Branch) or( bgt and maiMare);
 JumpAdress<="000"&instr(12 downto 0);
 
 --MUX memtoreg
 MUX_MEMTOREG:process(MemtoReg,ALURes,MemData)
                 begin
                     if MemtoReg='1' then 
                         WD<=MemData;
                     else
                         WD<=ALURes;
                     end if;
              end process;
 
MUX_AFISARE:process(sw(2 downto 0),afis,instr,pc)    
        begin
        case sw(2 downto 0) is
           when "000"=>afis<=instr;
           when "001"=>afis<=pc;
           when "010"=>afis<=RD1;
           when "011"=>afis<=RD2;
           when "100"=>afis<=Ext_Imm;
           when "101"=>afis<=ALURes;
           when "110"=>afis<=MemData;
           when "111"=>afis<=WD;
        end case;
        end process;
end Behavioral;
