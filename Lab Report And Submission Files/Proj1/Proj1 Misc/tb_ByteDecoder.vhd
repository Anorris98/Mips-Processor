library IEEE;
  use IEEE.std_logic_1164.all;

entity tb_ByteShifter is
  -- Testbench has no ports
end entity;

architecture behavior of tb_ByteShifter is
  -- Component Declaration for the Unit Under Test (UUT)
  component ByteShifter
    port (
        i_word   : in  std_logic_vector(31 downto 0); -- Input word
        i_offset : in  std_logic_vector(1 downto 0);  -- Two bits for 0 to 3 offsets
        o_Output : out std_logic_vector(31 downto 0); -- Output port
        i_signed : in  std_logic                      -- Sign flag: '1' for signed, '0' for unsigned
    );
  end component;

  -- Inputs
    signal s_word   : std_logic_vector(31 downto 0);
    signal s_offset : std_logic_vector(1 downto 0);
    signal s_Output : std_logic_vector(31 downto 0);
    signal s_signed : std_logic;  

begin
  -- Instantiate the Unit Under Test (UUT)
  uut: ByteShifter
    port map (
        i_word  => s_word,  -- Input word
        i_offset=> s_offset,   -- Two bits for 0 to 3 offsets
        o_Output=> s_Output,  -- Output port
        i_signed=> s_signed  
    );

  -- Stimulus process

  stim_proc: process
  begin
    -- Apply test vectors
    wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "00";     
    s_signed <= '0';         
    wait for 10 ns;

        wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "01";     
    s_signed <= '0';         
    wait for 10 ns;

        wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "10";     
    s_signed <= '0';         
    wait for 10 ns;

        wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "11";     
    s_signed <= '0';         
    wait for 10 ns;

        wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "00";     
    s_signed <= '1';         
    wait for 10 ns;

        wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "01";     
    s_signed <= '1';         
    wait for 10 ns;

        wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "10";     
    s_signed <= '1';         
    wait for 10 ns;

        wait for 10 ns;
    s_word   <= x"CCAA00FF";   --OUTPUT FF 
    s_offset <= "11";     
    s_signed <= '1';         
    wait for 10 ns;

    wait;
  end process;
end architecture;
