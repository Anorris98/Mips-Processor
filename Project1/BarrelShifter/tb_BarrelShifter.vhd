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
    P_TB : process
    begin
        -- Add additional test cases as needed...
        data_in <= x"7FFFFFFF";
        shift_type <= '0'; -- Logical shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x00000000 by the end

        data_in <= x"7FFFFFFF";
        shift_type <= '1'; -- Arithmetic shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x00000000 by the end

        data_in <= x"80000000";
        shift_type <= '0'; -- Logical shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x00000001 by the end

        data_in <= x"80000000";
        shift_type <= '1'; -- Arithmetic shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0xFFFFFFFF by the end

        data_in <= x"00000000";
        shift_type <= '0'; -- Logical shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x00000001 by the end

        data_in <= x"00000000";
        shift_type <= '1'; -- Arithmetic shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x00000000 by the end

        -- Add additional test cases as needed...
        data_in <= x"FFFFFFFF";
        shift_type <= '0'; -- Logical shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0x00000000 by the end

        data_in <= x"FFFFFFFF";
        shift_type <= '1'; -- Arithmetic shift
        for i in 0 to 31 loop
            shift_amount <= std_logic_vector(to_unsigned(i, 5));
            wait for 50 ns;
        end loop;
        wait for 50 ns;
        -- data_out should be 0xFFFFFFFF by the end
        -- run 13200

        -- End simulation
        wait;
    end process;
end behavior;
