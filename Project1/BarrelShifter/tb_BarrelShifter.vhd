library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_BarrelShifter is

end tb_BarrelShifter;

architecture behavior of tb_BarrelShifter is
    -- Component Declaration for the BarrelShifter
    component BarrelShifter is
        generic(N : integer := 32);
        port(
            i_in        : in  std_logic_vector(N-1 downto 0);
            i_shift_C   : in  std_logic;
            i_shamt     : in  std_logic_vector(4 downto 0);
            o_out       : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    -- Signals for interfacing with the BarrelShifter
    signal data_in      : std_logic_vector(31 downto 0);
    signal shift_type   : std_logic;
    signal shift_amount : std_logic_vector(4 downto 0);
    signal data_out     : std_logic_vector(31 downto 0);


    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: BarrelShifter
        port map (
            i_in        => data_in,
            i_shift_C   => shift_type,
            i_shamt     => shift_amount,
            o_out       => data_out
        );


    -- Test process
    process
    begin
        -- Test Case 1: Logical Right Shift by 1
        data_in <= "11110000111100001111000011110000";
        shift_type <= '0'; -- Logical shift
        shift_amount <= "00001";
        wait for 50 ns;
        
        -- Test Case 2: Logical Right Shift by 16
        data_in <= "11110000111100001111000011110000";
        shift_type <= '0'; -- Logical shift
        shift_amount <= "10000";
        wait for 50 ns;
        
        -- Test Case 3: Arithmetic Right Shift by 1 (Note: MSB should be preserved)
        data_in <= "11110000111100001111000011110000";
        shift_type <= '1'; -- Arithmetic shift
        shift_amount <= "00001";
        wait for 50 ns;

        -- Test Case 4: Arithmetic Right Shift by 16 (Note: MSB should be preserved)
        data_in <= "10000000111100001111000011110000";
        shift_type <= '1'; -- Arithmetic shift
        shift_amount <= "10000";
        wait for 50 ns;
        
        -- Add additional test cases as needed...

        -- End simulation
        wait;
    end process;
end behavior;
