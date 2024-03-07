library IEEE;
use IEEE.std_logic_1164.all;

entity controlLogic is
  port(instruct31_26    : in std_logic_vector(5 downto 0);
       instruct5_0	    : in std_logic_vector(5 downto 0);
       o_ALU_Ctl	    : out std_logic_vector(8 downto 0);
       o_RegWrite     	: out std_logic;
       o_MemtoReg	    : out std_logic;
       o_MemWrite       : out std_logic;
       o_MemRead		: out std_logic;
       o_RegDst       	: out std_logic_vector(1 downto 0);
       o_Branch       	: out std_logic;
       o_Alu_Src        : out std_logic;
       o_ext_ctl        : out std_logic; 
       o_Jump       	: out std_logic;       
       o_jr       	    : out std_logic;
       o_jal       	    : out std_logic);
end controlLogic;

architecture sel_when of controlLogic is
begin
op : process(instruct31_26)
begin
   case (instruct31_26) is
     when "001001" => --addi
        o_Alu_Src    <= '1';
        o_ALU_Ctl    <= "000000000";
        o_MemtoReg   <= '0';       
        o_MemWrite   <= '0';
        o_RegWrite   <= '1';
        o_RegDst     <= "00";
        o_Jump       <= '0';
        o_Branch     <= '0';        
        o_MemRead    <= '0';
        o_ext_ctl    <= '1';
        o_jal        <= '0';
        o_jr         <= '0';

    when "001001" => --addiu Same as Addi
        o_Alu_Src    <= '1';
        o_ALU_Ctl    <= "000000000";
        o_MemtoReg   <= '0';       
        o_MemWrite   <= '0';
        o_RegWrite   <= '1';
        o_RegDst     <= "00";
        o_Jump       <= '0';
        o_Branch     <= '0';        
        o_MemRead    <= '0';
        o_ext_ctl    <= '1';
        o_jal        <= '0';
        o_jr         <= '0';

    when "001100" => --andi
        o_Alu_Src    <= '1';
        o_ALU_Ctl    <= "000000011";
        o_MemtoReg   <= '0';       
        o_MemWrite   <= '0';
        o_RegWrite   <= '1';
        o_RegDst     <= "00";
        o_Jump       <= '0';
        o_Branch     <= '0';        
        o_MemRead    <= '0';
        o_ext_ctl    <= '0';
        o_jal        <= '0';
        o_jr         <= '0';
    
         end case;
end process;
end sel_when;