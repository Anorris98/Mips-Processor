LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU_tb IS
END ALU_tb;

ARCHITECTURE behavior OF ALU_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ALU
    GENERIC(N : integer := 32);
    PORT(
        i_ALU_A : IN  std_logic_vector(31 DOWNTO 0);
        i_ALU_B : IN  std_logic_vector(31 DOWNTO 0);
        i_ALU_Ctl : IN  std_logic_vector(8 DOWNTO 0);
        o_ALU_Carry : OUT  std_logic;
        o_ALU_Zero : OUT  std_logic;
        o_ALU_Overflow : OUT  std_logic;
        o_ALU_I_AddSub_Result : OUT  std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;
   
    --Inputs
    SIGNAL i_ALU_A : std_logic_vector(31 DOWNTO 0) := (others => '0');
    SIGNAL i_ALU_B : std_logic_vector(31 DOWNTO 0) := (others => '0');
    SIGNAL i_ALU_Ctl : std_logic_vector(8 DOWNTO 0) := (others => '0');

    --Outputs
    SIGNAL o_ALU_Carry : std_logic;
    SIGNAL o_ALU_Zero : std_logic;
    SIGNAL o_ALU_Overflow : std_logic;
    SIGNAL o_ALU_I_AddSub_Result : std_logic_vector(31 DOWNTO 0);

BEGIN 

    -- Instantiate the Unit Under Test (UUT)
    uut: ALU GENERIC MAP (N => 32) PORT MAP (
          i_ALU_A => i_ALU_A,
          i_ALU_B => i_ALU_B,
          i_ALU_Ctl => i_ALU_Ctl,
          o_ALU_Carry => o_ALU_Carry,
          o_ALU_Zero => o_ALU_Zero,
          o_ALU_Overflow => o_ALU_Overflow,
          o_ALU_I_AddSub_Result => o_ALU_I_AddSub_Result
        );

    -- Stimulus process
    stimulus: PROCESS
    BEGIN        
        -- Test Case 1: Add
        i_ALU_A <= X"00000001";
        i_ALU_B <= X"00000001";
        i_ALU_Ctl <= "000000000"; -- Assuming this is the control for add
        WAIT FOR 10 ns;
        
        -- Test Case 2: Subtract
        i_ALU_A <= X"00000003";
        i_ALU_B <= X"00000001";
        i_ALU_Ctl <= "000000001"; -- Assuming this is the control for subtract
        WAIT FOR 10 ns;

            -- Test Case 3: Shift Left Logical
        -- Assuming the control signal for shift left logical is represented in a specific bit pattern
        i_ALU_A <= X"00000001"; -- Input data to be shifted (not used in this case)
        i_ALU_B <= X"00000004"; -- Input data to be shifted
        i_ALU_Ctl <= "00010000"; 
        WAIT FOR 10 ns;
    
        -- Test Case 4: Shift Right Logical
        -- Adjust i_ALU_Ctl based on control for logical shift right
        i_ALU_A <= X"00000002"; -- Input data to be shifted (not used in this case)
        i_ALU_B <= X"00000008"; -- Input data to be shifted
        i_ALU_Ctl <= "000010001"; 
        WAIT FOR 10 ns;

        -- Test Case 5: Bitwise OR
        -- Assuming Control signal for OR is adjusted according to your component mappings
        i_ALU_A <= X"00000001";
        i_ALU_B <= X"00000002";
        i_ALU_Ctl <= "00100000"; -- Adjust based on control for OR operation
        WAIT FOR 10 ns;

        -- Test Case 6: Bitwise XOR
        -- Assuming Control signal for XOR is adjusted according to your component mappings
        i_ALU_A <= X"00000003";
        i_ALU_B <= X"00000001";
        i_ALU_Ctl <= "01000000"; -- Adjust based on control for XOR operation
        WAIT FOR 10 ns;
        
        -- Add other test cases here for shift left, shift right, logical shift right, and, or, xor, nor
        -- Make sure to define the correct control signals for each operation
        
        -- Test Case N: Example
        -- i_ALU_A <= ...;
        -- i_ALU_B <= ...;
        -- i_ALU_Ctl <= "..."; -- Control signal for the operation
        -- WAIT FOR 10 ns;

        WAIT; -- Will stop the simulation
    END PROCESS;

END behavior;
