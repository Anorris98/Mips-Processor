-------------------------------------------------------------------------
-- Author:   Alek Norris
-- Class:    CPRE 381
-- Implimentation of a 32 bit right barrel shifter.
-- Descirption(added for clarity on how it works and easy refrence later):
--  This VHDL code describes a 32-bit barrel shifter that can perform both
--  logical and arithmetic shifts to the right, based on a 5-bit shift 
--  amount (shift_amount). The operation type (logical or arithmetic) is 
--  determined by the shift_type signal. The barrel shifter is structured 
--  using a cascade of 2-to-1 muxes, organized into stages, 
--  where each stage doubles the shifting capability of the previous one, 
--  starting from 1-bit shifts up to 16-bit shifts in the final stage. 
--  This design allows for any shift amount between 0 and 31 bits by appropriately
--   selecting the path through the muxes based on the shift_amount value.   
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Entity Declaration
entity BarrelShifter is
    generic(N : integer := 32); -- Generic parameter to define word size
    port(
        i_in            : in  std_logic_vector(N-1 downto 0);  -- Input data to be shifted
        i_shift_C       : in  std_logic;                      -- Shift type: '0' for logical, '1' for arithmetic
        i_shamt         : in  std_logic_vector(4 downto 0);   -- Amount to shift/rotate the input data
        o_out           : out std_logic_vector(N-1 downto 0)  -- Output data after shifting
    );
end BarrelShifter;

-- Architecture Declaration
architecture behavior of BarrelShifter is
    -- Component Declaration for 2-to-1 Multiplexer
    component mux2t1_1 is
        port(
            i_D0   : in  std_logic;     -- Input 0
            i_D1   : in  std_logic;     -- Input 1
            i_S    : in  std_logic;     -- Selector
            o_O    : out std_logic      -- Output
        );
    end component;

    -- Signal Declarations
    signal fill_bit : std_logic := '0'; -- Bit used to fill vacated positions after shift
    -- Intermediate shift signals for each stage
    signal shift_stage_0, shift_stage_1, shift_stage_2, shift_stage_3 : std_logic_vector(N-1 downto 0);

begin
    -- Determine fill bit for arithmetic shifts
    ShiftLogic: process(i_in, i_shift_C)
    begin
        if i_shift_C = '1' and i_in(N-1) = '1' then
            fill_bit <= '1'; -- Use MSB as fill bit for arithmetic right shifts
        else
            fill_bit <= '0'; -- Use '0' for logical shifts or when MSB is '0'
        end if;
    end process ShiftLogic;

    -- Stage 0: Shift by 1 position
    mux0_31 : mux2t1_1 port map(i_in(N-1), fill_bit, i_shamt(0), shift_stage_0(N-1));
    G0: for i in N-2 downto 0 generate
        mux0_i : mux2t1_1 port map(i_in(i), i_in(i+1), i_shamt(0), shift_stage_0(i));
    end generate;

    -- Stage 1: Shift by 2 positions
    mux1_31 : mux2t1_1 port map(shift_stage_0(N-1), fill_bit, i_shamt(1), shift_stage_1(N-1));
    mux1_30 : mux2t1_1 port map(shift_stage_0(N-2), fill_bit, i_shamt(1), shift_stage_1(N-2));
    G1: for i in N-3 downto 0 generate
        mux1_i : mux2t1_1 port map(shift_stage_0(i), shift_stage_0(i+2), i_shamt(1), shift_stage_1(i));
    end generate;

    -- Stage 2: Shift by 4 positions
    G2_1: for i in N-1 downto N-4 generate
        mux2_i : mux2t1_1 port map(shift_stage_1(i), fill_bit, i_shamt(2), shift_stage_2(i));
    end generate;
    G2_2: for i in N-5 downto 0 generate
        mux2_i : mux2t1_1 port map(shift_stage_1(i), shift_stage_1(i+4), i_shamt(2), shift_stage_2(i));
    end generate;

    -- Stage 3: Shift by 8 positions
    G3_1: for i in N-1 downto N-8 generate
        mux3_i : mux2t1_1 port map(shift_stage_2(i), fill_bit, i_shamt(3), shift_stage_3(i));
    end generate;
    G3_2: for i in N-9 downto 0 generate
        mux3_i : mux2t1_1 port map(shift_stage_2(i), shift_stage_2(i+8), i_shamt(3), shift_stage_3(i));
    end generate;

    -- Stage 4: Shift by 16 positions
    G4_1: for i in N-1 downto 16 generate
        mux4_i: mux2t1_1 port map(shift_stage_3(i), fill_bit, i_shamt(4), o_out(i));
    end generate;
    G4_2: for i in 15 downto 0 generate
        mux4_i: mux2t1_1 port map(shift_stage_3(i), shift_stage_3(i+16), i_shamt(4), o_out(i));
    end generate;

end behavior;
