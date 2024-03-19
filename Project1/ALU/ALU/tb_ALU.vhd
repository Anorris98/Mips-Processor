library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_ALU is
end entity;

architecture behavior of tb_ALU is

  -- Component Declaration for the Unit Under Test (UUT)
  component ALU
    generic (N : integer := 32);
    port (
      i_ALU_A               : in  std_logic_vector(31 downto 0);
      i_ALU_B               : in  std_logic_vector(31 downto 0);
      i_ALU_Ctl             : in  std_logic_vector(3 downto 0);
      o_ALU_Carry           : out std_logic;
      o_ALU_Zero            : out std_logic;
      o_ALU_Overflow        : out std_logic;
      o_ALU_I_Result : out std_logic_vector(31 downto 0)
    );
  end component;

  --Inputs
  signal i_ALU_A   : std_logic_vector(31 downto 0) := (others => '0');
  signal i_ALU_B   : std_logic_vector(31 downto 0) := (others => '0');
  signal i_ALU_Ctl : std_logic_vector(3 downto 0)  := (others => '0');

  --Outputs
  signal o_ALU_Carry           : std_logic;
  signal o_ALU_Zero            : std_logic;
  signal o_ALU_Overflow        : std_logic;
  signal o_ALU_I_Result : std_logic_vector(31 downto 0);

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: ALU
    generic map (N => 32)
    port map (
      i_ALU_A               => i_ALU_A,
      i_ALU_B               => i_ALU_B,
      i_ALU_Ctl             => i_ALU_Ctl,
      o_ALU_Carry           => o_ALU_Carry,
      o_ALU_Zero            => o_ALU_Zero,
      o_ALU_Overflow        => o_ALU_Overflow,
      o_ALU_I_Result => o_ALU_I_Result
    );

  -- Stimulus process

  stimulus: process
  begin
    -- Test Case 1: Add
    i_ALU_A <= X"00000001";
    i_ALU_B <= X"00000001";
    i_ALU_Ctl <= "0000"; -- Add, should be 2
    wait for 10 ns;

    -- Test Case 2: Subtract
    i_ALU_A <= X"00000003";
    i_ALU_B <= X"00000001";
    i_ALU_Ctl <= "1000"; -- sub, should be 2
    wait for 10 ns;

    -- Test Case 3: Shift Left Logical
    i_ALU_A <= X"00000002"; -- shamt field is 4-0
    i_ALU_B <= X"00000004"; -- Input data to be shifted
    i_ALU_Ctl <= "0010"; --shift left logical, should be 16
    wait for 10 ns;

    -- Test Case 4: Shift Right Logical
    i_ALU_A <= X"00000008"; -- shamt field is 4-0
    i_ALU_B <= X"00000002"; -- Input data to be shifted
    i_ALU_Ctl <= "0001"; -- srl, should be 2
    wait for 10 ns;

    -- Test Case 5: Bitwise OR
    i_ALU_A <= X"FFFFFFFF";
    i_ALU_B <= X"00000000";
    i_ALU_Ctl <= "0100"; --or, Should be FFFFFFFF
    wait for 10 ns;

    -- Test Case 6: Bitwise XOR
    i_ALU_A <= X"0F0F0F0F";
    i_ALU_B <= X"FFFFFFFF";
    i_ALU_Ctl <= "0101"; -- xor , should be F0F0F0F0
    wait for 10 ns;

    -- Test Case 7: Bitwise NOR
    i_ALU_A <= X"FFFF000F";
    i_ALU_B <= X"F0F0000F";
    i_ALU_Ctl <= "0110"; -- Nor, should be 0000FFF0
    wait for 10 ns;

    -- Test Case 8: Bitwise AND
    i_ALU_A <= X"FFF00A01";
    i_ALU_B <= X"FFF00A02";
    i_ALU_Ctl <= "0011"; -- and, should be FFF00A00
    wait for 10 ns;

    wait;
  end process;

end architecture;
