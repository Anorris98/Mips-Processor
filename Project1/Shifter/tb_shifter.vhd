library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Shifter is
end tb_Shifter;

architecture behavior of tb_Shifter is

    -- Component Declaration for the Unit Under Test (UUT)
    component Shifter
        generic (N : integer := 32);
        port (
            i_in : in std_logic_vector(31 downto 0);
            i_shift_C : in std_logic;
            i_direction : in std_logic;
            i_shamt : in std_logic_vector(4 downto 0);
            o_Out : out std_logic_vector(31 downto 0)
        );
    end component;

    --Inputs
    signal i_in : std_logic_vector(31 downto 0) := (others => '0');
    signal i_shift_C : std_logic := '0';
    signal i_direction : std_logic := '0';
    signal i_shamt : std_logic_vector(4 downto 0) := (others => '0');

    --Outputs
    signal o_Out : std_logic_vector(31 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : Shifter generic map(
        N => 32) port map (
        i_in => i_in,
        i_shift_C => i_shift_C,
        i_direction => i_direction,
        i_shamt => i_shamt,
        o_Out => o_Out
    );

    -- Stimulus process to apply test vectors
    stimulus : process
    begin
        -- Test Case 1: Logical Right Shift by 2
        i_in <= x"80000000";
        i_shift_C <= '0'; -- Logical shift
        i_direction <= '1'; -- Right shift
        i_shamt <= "00010"; -- Shift by 2
        wait for 100 ns;

        -- Test Case 2: Logical Left Shift by 4
        i_in <= x"00000001";
        i_shift_C <= '0'; -- Logical shift
        i_direction <= '0'; -- Left shift
        i_shamt <= "00100"; -- Shift by 4
        wait for 100 ns;

        -- Test Case 3: Arithmetic Right Shift by 3
        i_in <= x"80000000";
        i_shift_C <= '1'; -- Arithmetic shift
        i_direction <= '1'; -- Right shift
        i_shamt <= "00011"; -- Shift by 3
        wait for 100 ns;

        -- Test Case 4: Arithmetic Left Shift (should behave like logical) by 2
        i_in <= x"00000001";
        i_shift_C <= '1'; -- Arithmetic shift
        i_direction <= '0'; -- Left shift
        i_shamt <= "00010"; -- Shift by 2
        wait for 100 ns;

        -- Add additional test cases as needed...
        i_in <= x"00000001";
        i_shift_C <= '0'; -- Logical shift
        i_direction <= '0'; -- Left shift
        for i in 0 to 31 loop
            i_shamt <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x80000000 by the end

        i_in <= x"00000001";
        i_shift_C <= '1'; -- Logical shift on left shift should still produce 0 filled values
        i_direction <= '0'; -- Left shift
        for i in 0 to 31 loop
            i_shamt <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x80000000 by the end

        -- End simulation
        wait;
    end process;

end behavior;