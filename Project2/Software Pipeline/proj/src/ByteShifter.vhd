
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ByteShifter is
    port (
        i_word   : in  std_logic_vector(31 downto 0); -- Input word
        i_offset : in  std_logic_vector(1 downto 0);  -- Two bits for 0 to 3 offsets
        o_Output : out std_logic_vector(31 downto 0); -- Output port
        i_signed : in  std_logic                      -- Sign flag: '1' for signed, '0' for unsigned
    );
end ByteShifter;

architecture behavior of ByteShifter is
    component Shifter
        generic (N : integer := 32);
        port (
            i_in        : in  std_logic_vector(N - 1 downto 0); -- Input data to be shifted
            i_shift_C   : in  std_logic; -- Shift type: (0) Logical, (1) Arithmetic
            i_direction : in  std_logic; -- Shift direction: (0) Left, (1) Right
            i_shamt     : in  std_logic_vector(4 downto 0); -- Amount to shift
            o_Out       : out std_logic_vector(N - 1 downto 0) -- Result of the shift operation
        );
    end component;

    component andg2
    port(i_A          : in std_logic;
    i_B          : in std_logic;
    o_F          : out std_logic
    );
    end component;

    component ByteDecoder
    Port ( i_offset : in STD_LOGIC_VECTOR(1 downto 0);
    o_output : out STD_LOGIC_VECTOR(4 downto 0));
    end component;

    
    signal inital_output: std_logic_vector(31 downto 0);
    signal final_output: std_logic_vector(31 downto 0);
    signal inital_Shamt: std_logic_vector(4 downto 0);
    signal final_Shamt: std_logic_vector(4 downto 0);
    signal andg2_output: std_logic;

begin

    ByteDecoder_inst: ByteDecoder
    port map (
    i_offset => i_offset,
    o_output => inital_Shamt
    );

    o_Output <= final_output;


    -- Shifter instance for initial left shift to position the byte
    initial_shift: Shifter
        generic map (N => 32)
        port map (
            i_in => i_word,
            i_shift_C => '0', -- Logical shift
            i_direction => '0', -- Left shift
            i_shamt => inital_Shamt, -- Shift amount based on offset
            o_Out => inital_output
        );

        andg2_inst: andg2
        port map (
        i_A => i_signed,
        i_B => inital_output(31),
        o_F => andg2_output
        );

    -- Shifter instance for right shift, potentially with sign extension
    final_shift: Shifter
        generic map (N => 32)
        port map (
            i_in => inital_output,
            i_shift_C => andg2_output, -- Determines if logical or arithmetic shift
            i_direction => '1', -- Right shift
            i_shamt => "11000", -- Shift right to align and possibly extend sign
            o_Out => final_output
        );



end behavior;

