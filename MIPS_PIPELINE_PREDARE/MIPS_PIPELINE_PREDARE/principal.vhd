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
    port(WRITEDATA:in std_logic_vector(2 downto 0);
        clk:in std_logic;
         buton : in std_logic;
        RegWr,RegDst,ExtOp:in std_logic;
        instr,WD:in std_logic_vector(15 downto 0);
        RD1,RD2,Ext_Imm:out std_logic_vector(15 downto 0);
        func:out std_logic_vector(2 downto 0);
        sa:out std_logic;   
        MUX_rt_rd:out std_logic_vector(2 downto 0)); 
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

signal WA:std_logic_vector(2 downto 0);
signal IF_ID:std_logic_vector(31 downto 0);
signal ID_EX:std_logic_vector(93 downto 0);
signal EX_MEM:std_logic_vector(71 downto 0);
signal MEM_WB:std_logic_vector(50 downto 0);

begin
    WEN: MPG port map(btn_nou,btn(0),clk);
    Afisor:SSD port map(afis,clk,an,cat);
    InF:Instruction_Fetch port map(clk,EX_MEM(25 downto 10),JumpAdress,MEM_WB(37),PCSrc,btn_nou,instr,pc); 
    Control:MainControl port map(IF_ID(15 downto 13),IF_ID(2 downto 0), RegDest,RegW,ExtOp,AluSrc,MemW,MemtoReg,Branch,Jump,bgt,AluCtrl);
    InD:InstrDecode port map( MEM_WB(2 downto 0),clk,btn_nou,MEM_WB(4),RegDest,ExtOp,IF_ID(15 downto 0),WD,RD1,RD2,Ext_Imm,func,sa,WA); 
    ALU:ExecutionUnit port map(ID_EX(79 downto 64),ID_EX(63 downto 48),ID_EX(47 downto 32),ID_EX(31 downto 16),ID_EX(12),ID_EX(3),ID_EX(11 downto 9),ID_EX(2 downto 0),zero,maiMare,ALURes,BranchAdress);
    MemoryRAM:MemoryUnit port map(EX_MEM(57 downto 42),EX_MEM(41 downto 26),clk,btn_nou,EX_MEM(7),ALUResO,MemData);            
  
 --SI LA SALT + BGT
 --PCSrc<=(zero and Branch) or( bgt and maiMare);
 --JumpAdress<="000"&instr(12 downto 0);
 PCSrc<=(EX_MEM(4) and  EX_MEM(6)) or( EX_MEM(5) and EX_MEM(3));
 JumpAdress<="000"&MEM_WB(50 downto 38);
 
 --MUX memtoreg
 MUX_MEMTOREG:process(MEM_WB(3),MEM_WB(20 downto 5),MEM_WB(36 downto 21))
                 begin
                     if MEM_WB(3)='1' then 
                         WD<=MEM_WB(36 downto 21);
                     else
                         WD<=MEM_WB(20 downto 5);
                     end if;
              end process;
 
MUX_AFISARE:process(sw(15),sw(8 downto 7),sw(5 downto 4),sw(2 downto 0),afis,instr,pc,IF_ID,ID_EX,EX_MEM,MEM_WB)    
        begin
        if sw(15)='0' then
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
        else 
            case sw(8 downto 7) is
                when "00"=>case sw(4) is
                                when '0'=>afis<= IF_ID(31 downto 16);       --pc;
                                when '1'=>afis<=IF_ID(15 downto 0);         --instr;
                            end case;
                when "01"=>case sw(5 downto 4) is
                                when "00"=>afis<= ID_EX(79 downto 64);       --pc;
                                when "01"=>afis<=ID_EX(63 downto 48);        --RD1;
                                when "10"=>afis<= ID_EX(47 downto 32);       --RD2;
                                when "11"=>afis<=ID_EX(31 downto 16);         --Ext_Imm;
                            end case;
                when "10"=>case sw(5 downto 4) is
                                when "00"=>afis<=EX_MEM(25 downto 10);      --BranchAdress;
                                when "01"=>afis<=EX_MEM(41 downto 26);      --RD2;
                                when "10"=>afis<=EX_MEM(57 downto 42);      --AluRes;
                                when "11"=>afis<=x"FFFF";
                            end case;
                when "11"=>case sw(4) is
                                when '0'=>afis<=MEM_WB(36 downto 21);            --MemData;
                                when '1'=>afis<=MEM_WB(20 downto 5);      --AluRes;
                            end case;
                            led(2 downto 0)<=MEM_WB(2 downto 0);
            end case;
        end if;
        end process;
        
registru_IF_ID:process(clk)
                begin
                    if rising_edge(clk) then
                        if btn_nou='1' then 
                            IF_ID(31 downto 16)<=pc;
                            IF_ID(15 downto 0)<=instr;
                        end if;
                    end if;
                end process;
                
registru_ID_EX:process(clk)
                begin
                    if rising_edge(clk) then
                        if btn_nou='1' then 
                            ID_EX(93 downto 81)<=IF_ID(12 downto 0);
                            ID_EX(80)<=Jump;
                            ID_EX(79 downto 64)<=IF_ID(31 downto 16); --pc
                            ID_EX(63 downto 48 )<=RD1;
                            ID_EX(47 downto 32)<=RD2;
                            ID_EX(31 downto 16)<=Ext_Imm;
                            ID_EX(15 downto 13)<=WA;
                            ID_EX(12)<=sa;
                            ID_EX(11 downto 9)<=func;
                            ID_EX(8)<=RegW;
                            ID_EX(7)<=MemtoReg;
                            ID_EX(6)<=MemWrite;
                            ID_EX(5)<=Branch;
                            ID_EX(4)<=bgt;
                            ID_EX(3)<=ALUSrc;
                            ID_EX(2 downto 0)<=AluCtrl;                                                     
                         end if;
                    end if;
                end process;
                
registru_EX_MEM:process(clk)
                begin
                    if rising_edge(clk) then
                        if btn_nou='1' then 
                            EX_MEM(71 downto 59)<=ID_EX(93 downto 81);
                            EX_MEM(58)<=ID_EX(80);      --jump
                            EX_MEM(57 downto 42)<=AluRes;
                            EX_MEM(41 downto 26)<=ID_EX(47 downto 32);  --RD2
                            EX_MEM(25 downto 10)<=BranchAdress;
                            EX_MEM(9)<=ID_EX(8);    --  RegW
                            EX_MEM(8)<=ID_EX(7);    --  MemtoReg
                            EX_MEM(7)<=ID_EX(6);    --  MemWrite
                            EX_MEM(6)<=ID_EX(5);    --Branch
                            EX_MEM(5)<=ID_EX(4);    --bgt
                            EX_MEM(4)<=zero;
                            EX_MEM(3)<=maiMare;
                            EX_MEM(2 downto 0)<=ID_EX(15 downto 13); --WA
                        end if;
                    end if;
                end process;
                
registru_MEM_WB:process(clk)
                begin
                if rising_edge(clk) then
                    if btn_nou='1' then
                        MEM_WB(50 downto 38)<=EX_MEM(71 downto 59);
                        MEM_WB(37)<= EX_MEM(58);    --jump
                        MEM_WB(36 downto 21)<=MemData;
                        MEM_WB(20 downto 5)<=ALUResO;   --AluRes
                        MEM_WB(4)<=EX_MEM(9);   --RegW
                        MEM_WB(3)<=EX_MEM(8);   --MemtoReg
                        MEM_WB(2 downto 0)<=EX_MEM(2 downto 0); --WA
                    end if;
                end if;
                end process;
end Behavioral;
