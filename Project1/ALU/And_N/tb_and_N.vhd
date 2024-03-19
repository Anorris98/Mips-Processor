library IEEE;
use IEEE.std_logic_1164.all;

entity and_N_tb is
-- Testbench has no ports!
end and_N_tb;

architecture behavior of and_N_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component and_N
        generic(N : integer := 32);
        port(
            i_A  : in  std_logic_vector(N-1 downto 0);
            i_B  : in  std_logic_vector(N-1 downto 0);
            o_Out: out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Parameters
    constant N : integer := 32;

    -- Input signals
    signal i_A  : std_logic_vector(N-1 downto 0);
    signal i_B  : std_logic_vector(N-1 downto 0);

    -- Output signal
    signal o_Out: std_logic_vector(N-1 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: and_N
        generic map (N => N)
        port map (
            i_A  => i_A,
            i_B  => i_B,
            o_Out=> o_Out
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: All zeros
        i_A <= (others => '0');
        i_B <= (others => '0');
        wait for 100 ns;
        
        -- Test case 2: All ones
        i_A <= (others => '1');
        i_B <= (others => '1');
        wait for 100 ns;
        
        -- Test case 3: A is all ones, B is alternating zeros and ones
        i_A <= (others => '1');
        i_B <= "10101010101010101010101010101010";
        wait for 100 ns;

        -- Test case 4: A is alternating zeros and ones, B is all ones
        i_A <= "10101010101010101010101010101010";
        i_B <= (others => '1');
        wait for 100 ns;

        -- Test case 5: A and B are opposite
        i_A <= "11110000111100001111000011110000";
        i_B <= "00001111000011110000111100001111";
        wait for 100 ns;

        -- Test case 6: Random pattern
        i_A <= "11001100110011001100110011001100";
        i_B <= "00110011001100110011001100110011";
        wait for 100 ns;

        -- End simulation
        wait;
    end process;
end behavior;
