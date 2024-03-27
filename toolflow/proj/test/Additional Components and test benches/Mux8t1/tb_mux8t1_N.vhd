library IEEE;
use IEEE.std_logic_1164.all;

entity mux8t1_N_tb is
-- Testbench has no ports
end mux8t1_N_tb;

architecture behavior of mux8t1_N_tb is
    -- Constants for the testbench
    constant N : integer := 32;
    
    -- Component Declaration for the Unit Under Test (UUT)
    component mux8t1_N
        generic(N : integer := 32);
        port(
            i_w0, i_w1, i_w2, i_w3,
            i_w4, i_w5, i_w6, i_w7 : in std_logic_vector(N-1 downto 0);
            i_s0, i_s1, i_s2       : in std_logic;
            o_Y                    : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    -- Input Signals
    signal i_w0, i_w1, i_w2, i_w3 : std_logic_vector(N-1 downto 0);
    signal i_w4, i_w5, i_w6, i_w7 : std_logic_vector(N-1 downto 0);
    signal i_s0, i_s1, i_s2       : std_logic;
    
    -- Output Signal
    signal o_Y                    : std_logic_vector(N-1 downto 0);
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: mux8t1_N
        generic map (N => N)
        port map (
            i_w0 => i_w0, i_w1 => i_w1, i_w2 => i_w2, i_w3 => i_w3,
            i_w4 => i_w4, i_w5 => i_w5, i_w6 => i_w6, i_w7 => i_w7,
            i_s0 => i_s0, i_s1 => i_s1, i_s2 => i_s2,
            o_Y => o_Y
        );
    
    -- Stimulus process to define test cases
    stim_proc: process
    begin
        -- Initialize inputs
        i_w0 <= (others => '0'); i_w1 <= (others => '0'); i_w2 <= (others => '0'); i_w3 <= (others => '0');
        i_w4 <= (others => '0'); i_w5 <= (others => '0'); i_w6 <= (others => '0'); i_w7 <= (others => '0');
        -- Set specific values to distinguish inputs
        i_w0 <= "00000000000000000000000000000000";
        i_w1 <= "00000000000000000000000000000001";
        i_w2 <= "00000000000000000000000000000010";
        i_w3 <= "00000000000000000000000000000011";
        i_w4 <= "00000000000000000000000000000100";
        i_w5 <= "00000000000000000000000000000101";
        i_w6 <= "00000000000000000000000000000110";
        i_w7 <= "00000000000000000000000000000111";
        
        -- Test Case 1: Select i_w0
        i_s0 <= '0'; i_s1 <= '0'; i_s2 <= '0';
        wait for 100 ns;
        
        -- Test Case 2: Select i_w1
        i_s0 <= '1'; i_s1 <= '0'; i_s2 <= '0';
        wait for 100 ns;
        
        -- Test Case 3: Select i_w2
        i_s0 <= '0'; i_s1 <= '1'; i_s2 <= '0';
        wait for 100 ns;
        
        -- Test Case 4: Select i_w3
        i_s0 <= '1'; i_s1 <= '1'; i_s2 <= '0';
        wait for 100 ns;

        -- Test Case 5: Select i_w4
        i_s0 <= '0'; i_s1 <= '0'; i_s2 <= '1';
        wait for 100 ns;
	
        -- Test Case 6: Select i_w5
        i_s0 <= '1'; i_s1 <= '0'; i_s2 <= '1';
        wait for 100 ns;

        -- Test Case 7: Select i_w6
        i_s0 <= '0'; i_s1 <= '1'; i_s2 <= '1';
        wait for 100 ns;
        
        -- Test Case 8: Select i_w7
        i_s0 <= '1'; i_s1 <= '1'; i_s2 <= '1';
        wait for 100 ns;
        
        -- End the simulation
        wait;
    end process;

end behavior;
