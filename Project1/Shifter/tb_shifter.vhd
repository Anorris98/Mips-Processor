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

    -- Test bench
    P_TB : process
    begin
        --------------------------------------------------
        -- Left shift tests
        -- run 3300 for just left shift tests
        --------------------------------------------------
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
        i_shift_C <= '1'; -- Arithmetic shift on left shift should still produce 0 filled values
        i_direction <= '0'; -- Left shift
        for i in 0 to 31 loop
            i_shamt <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x80000000 by the end

        --------------------------------------------------
        -- Right shift tests
        -- run 6600 for right shift tests, start at 3300 ns
        --------------------------------------------------
        i_in <= x"80000000";
        i_shift_C <= '0'; -- Logical shift
        i_direction <= '1'; -- Right shift
        for i in 0 to 31 loop
            i_shamt <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x00000001 by the end

        i_in <= x"80000000";
        i_shift_C <= '1'; -- Arithmetic shift
        i_direction <= '1'; -- Right shift
        for i in 0 to 31 loop
            i_shamt <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0xFFFFFFFF by the end

        -- End simulation
        wait;
    end process;

end behavior;