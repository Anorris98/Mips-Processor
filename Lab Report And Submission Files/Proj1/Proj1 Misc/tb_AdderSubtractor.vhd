-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
--implimentaition of an AdderSubtractor with a 1 bit selector 0=add, 1=subtract
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O


entity tb_AdderSubtractor is
end tb_AdderSubtractor;

-- Test Bench Architecture
architecture mixed of tb_AdderSubtractor is
    constant    s_N                                         :   integer := 32;  -- constant, define the bit width for the test
    signal      s_A, s_B, s_Sum                             :   std_logic_vector(s_N-1 downto 0);
    signal      s_nAdd_Sub, s_Overflow, s_Cout, s_Zero      :   std_logic;

begin
    DUT0: entity work.AdderSubtractor
    generic map (N => s_N)
    port map   (iA         => s_A, 
                iB         => s_B, 
                iC  => s_nAdd_Sub,
                oS       => s_Sum,
                oC      => s_Cout,
                o_AddSub_Overflow  => s_Overflow,
                o_AddSub_Zero      => s_Zero
                );
    
    -- Stimulus process
    stim_proc: process
    begin
     
     --test #1, addition, Result = 0110 
        s_A         <= "00000000000000000000000000010000";
        s_B         <= "00000000000000000000000000000010";
        s_nAdd_Sub  <= '0';
            wait for 10 ns;

    --test #2, addition, Result = 1100
        s_A         <= "00000000000000000000000000101111";
        s_B         <= "00000000000000000000000000000111";
        s_nAdd_Sub  <= '0';
            wait for 10 ns;  

    --test #3, subtraction, Result = 101111
        s_A         <= "00000000000000000000000000111000";
        s_B         <= "00000000000000000000000000001001";
        s_nAdd_Sub  <= '1';
            wait for 10 ns;    

     --test #4, subtraction, Result = 0111
        s_A         <= "00000000000000000000000000100110";
        s_B         <= "00000000000000000000000000000001";
        s_nAdd_Sub  <= '1';
            wait for 10 ns;                  

     --test #5, subtraction, Result = 0000
        s_A         <= "00000000000000000000000000000111";
        s_B         <= "00000000000000000000000000000111";
        s_nAdd_Sub  <= '1';
            wait for 10 ns;   

    --test #6, addition, Result = 0xfffffffe 
        s_A         <= x"FFFFFFFF";
        s_B         <= X"FFFFFFFF";
        s_nAdd_Sub  <= '0';
            wait for 10 ns;   

     -- Test #6: Addition leading to overflow
    s_A         <= x"7FFFFFFF"; -- Max positive value for a 32-bit signed integer
    s_B         <= X"00000001"; -- Adding 1 should cause overflow
    s_nAdd_Sub  <= '0';
    wait for 10 ns;  

    -- Test #7: Addition, should result in a 0. -1 +1 is 0.
    s_A         <= x"FFFFFFFF"; 
    s_B         <= X"00000001"; 
    s_nAdd_Sub  <= '0';
    wait for 10 ns;

    -- Test #8: Subtracting from zero, 0 - 1 = 0xffffffff
    s_A         <= x"00000000"; 
    s_B         <= X"00000001"; 
    s_nAdd_Sub  <= '1';
    wait for 10 ns;

        wait;        
    end process stim_proc;
end mixed;