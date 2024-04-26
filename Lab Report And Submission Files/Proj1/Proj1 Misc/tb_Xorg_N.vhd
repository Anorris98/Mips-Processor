library IEEE;
use IEEE.std_logic_1164.all;

entity xorg_N_tb is
-- Testbench has no ports!
end xorg_N_tb;

architecture behavior of xorg_N_tb is
    -- Constants for the testbench
    constant N : integer := 32;
    
    -- Component Declaration for the Unit Under Test (UUT)
    component xorg_N
        generic(N : integer := 32);
        port(
            i_A   : in  std_logic_vector(N-1 downto 0);
            i_B   : in  std_logic_vector(N-1 downto 0);
            o_out : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    -- Input signals
    signal i_A   : std_logic_vector(N-1 downto 0);
    signal i_B   : std_logic_vector(N-1 downto 0);
    
    -- Output signal
    signal o_out : std_logic_vector(N-1 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: xorg_N
        generic map (N => N)
        port map (
            i_A   => i_A,
            i_B   => i_B,
            o_out => o_out
        );
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: All zeros
        i_A <= (others => '0');
        i_B <= (others => '0');
        wait for 100 ns;
        
        -- Test case 2: A is all ones, B is all zeros
        i_A <= (others => '1');
        i_B <= (others => '0');
        wait for 100 ns;
        
        -- Test case 3: A is all zeros, B is all ones
        i_A <= (others => '0');
        i_B <= (others => '1');
        wait for 100 ns;
        
        -- Test case 4: Both A and B are all ones
        i_A <= (others => '1');
        i_B <= (others => '1');
        wait for 100 ns;
        
        -- Test case 5: A and B are alternating zeros and ones
        i_A <= "10101010101010101010101010101010";
        i_B <= "01010101010101010101010101010101";
        wait for 100 ns;

        -- Test case 6: Opposite of case 5
        i_A <= "01010101010101010101010101010101";
        i_B <= "10101010101010101010101010101010";
        wait for 100 ns;
        
        -- Additional test cases as desired

        -- End simulation
        wait;
    end process;
end behavior;
