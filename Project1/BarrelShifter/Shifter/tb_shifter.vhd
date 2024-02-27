LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_Shifter IS
END tb_Shifter;

ARCHITECTURE behavior OF tb_Shifter IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Shifter
    GENERIC(N : INTEGER := 32);
    PORT(
        i_in       : IN  std_logic_vector(31 DOWNTO 0);
        i_shift_C  : IN  std_logic;
        i_direction : IN  std_logic;
        i_shamt    : IN  std_logic_vector(4 DOWNTO 0);
        o_Out      : OUT std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;
   
    --Inputs
    signal i_in : std_logic_vector(31 downto 0) := (others => '0');
    signal i_shift_C : std_logic := '0';
    signal i_direction : std_logic := '0';
    signal i_shamt : std_logic_vector(4 downto 0) := (others => '0');

    --Outputs
    signal o_Out : std_logic_vector(31 downto 0);

BEGIN 

    -- Instantiate the Unit Under Test (UUT)
    uut: Shifter GENERIC MAP (N => 32) PORT MAP (
          i_in => i_in,
          i_shift_C => i_shift_C,
          i_direction => i_direction,
          i_shamt => i_shamt,
          o_Out => o_Out
        );

    -- Stimulus process to apply test vectors
    stimulus: PROCESS
    BEGIN
        -- Test Case 1: Logical Right Shift by 2
        i_in <= "10000000000000000000000000000000";
        i_shift_C <= '0';  -- Logical shift
        i_direction <= '1'; -- Right shift
        i_shamt <= "00010"; -- Shift by 2
        WAIT FOR 100 ns;
        
        -- Test Case 2: Logical Left Shift by 4
        i_in <= "00000000000000000000000000000001";
        i_shift_C <= '0';  -- Logical shift
        i_direction <= '0'; -- Left shift
        i_shamt <= "00100"; -- Shift by 4
        WAIT FOR 100 ns;

        -- Test Case 3: Arithmetic Right Shift by 3
        i_in <= "10000000000000000000000000000000";
        i_shift_C <= '1';  -- Arithmetic shift
        i_direction <= '1'; -- Right shift
        i_shamt <= "00011"; -- Shift by 3
        WAIT FOR 100 ns;

        -- Test Case 4: Arithmetic Left Shift (should behave like logical) by 2
        i_in <= "00000000000000000000000000000001";
        i_shift_C <= '1';  -- Arithmetic shift
        i_direction <= '0'; -- Left shift
        i_shamt <= "00010"; -- Shift by 2
        WAIT FOR 100 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;
