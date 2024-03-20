-------------------------------------------------------------------------
-- Author:   Alek Norris
-- Class:    CPRE 381
-- Implementation of a 32-bit bidirectional barrel shifter.
-- This design allows for both logical and arithmetic shifts
-- to the left or right, depending on the input signals.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Shifter is
    generic (N : integer := 32);
    port (
        i_in : in std_logic_vector(N - 1 downto 0); -- Input data to be shifted
        i_shift_C : in std_logic; -- Shift type: (0) Logical, (1) Arithmetic
        i_direction : in std_logic; -- Shift direction: (0) Left, (1) Right
        i_shamt : in std_logic_vector(4 downto 0); -- Amount to shift
        o_Out : out std_logic_vector(N - 1 downto 0) -- Result of the shift operation
    );
end Shifter;

architecture behavior of Shifter is

    -- Component declarations
    component BarrelShifter
        generic (N : integer := 32);
        port (
            i_in : in std_logic_vector(N - 1 downto 0);
            i_shift_C : in std_logic;
            i_shamt : in std_logic_vector(4 downto 0);
            o_out : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component mux2t1_N
        generic (N : integer := 32);
        port (
            i_s : in std_logic;
            i_D0 : in std_logic_vector(N - 1 downto 0);
            i_D1 : in std_logic_vector(N - 1 downto 0);
            o_O : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component andg2 is
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);
    end component;

    -- Intermediate signals
    signal s_bit_reversed_data : std_logic_vector(N - 1 downto 0); -- Bit-reversed input data for direction handling
    signal s_mux_output : std_logic_vector(N - 1 downto 0); -- Output of the first MUX, input to the shifter
    signal s_shifted_data : std_logic_vector(N - 1 downto 0); -- Output of the barrel shifter
    signal s_final_output : std_logic_vector(N - 1 downto 0); -- Final output after potential bit-reversal
    signal s_shift_c : std_logic; -- holds value of logical or arithmetic shift 

begin

    -- Reverse the bits of the input data if the shift direction is left
    BitReverse : for i in 0 to N - 1 generate
        s_bit_reversed_data(i) <= i_in((N - 1) - i);
    end generate;

    -- Select the appropriate input for the shifter based on the direction
    InputSelect : mux2t1_N
    generic map(N => N)
    port map(
        i_s => i_direction,
        i_D1 => i_in, -- Use original data for right shift
        i_D0 => s_bit_reversed_data, -- Use bit-reversed data for left shift
        o_O => s_mux_output
    );

    -- Obtain arithmetic shift or logical shift
    -- 0 if logical, 1 if arithmetic.
    -- can only be 1 if i_direction = 1 (right shift) AND i_shift_C = 1 (arithmetic shift)
    ShiftType : andg2
    port map(
        i_A => i_shift_C,
        i_B => i_direction,
        o_F => s_shift_C
    );

    -- Perform the shift operation
    ShiftOperation : BarrelShifter
    generic map(N => N)
    port map(
        i_in => s_mux_output,
        i_shift_C => s_shift_C,
        i_shamt => i_shamt,
        o_out => s_shifted_data
    );

    -- Reverse the bits of the output data if the shift direction was left
    OutputBitReverse : for i in 0 to N - 1 generate
        s_final_output(i) <= s_shifted_data((N - 1) - i);
    end generate;

    -- Select the final output based on the shift direction
    OutputSelect : mux2t1_N
    generic map(N => N)
    port map(
        i_s => i_direction,
        i_D1 => s_shifted_data, -- Use shifted data directly for right shift
        i_D0 => s_final_output, -- Use bit-reversed shifted data for left shift
        o_O => o_Out
    );

end behavior;