library IEEE;
  use IEEE.std_logic_1164.all;

entity tb_Controller is
  -- Testbench has no ports
end entity;

architecture behavior of tb_Controller is
  -- Component Declaration for the Unit Under Test (UUT)
  component Controller
    port (
      i_instruct31_26 : in  std_logic_vector(5 downto 0);
      i_instruct5_0   : in  std_logic_vector(5 downto 0);
      o_ALU_Ctl       : out std_logic_vector(3 downto 0);
      o_RegWrite      : out std_logic;
      o_MemtoReg      : out std_logic;
      o_MemWrite      : out std_logic;
      o_MemRead       : out std_logic;
      o_RegDst        : out std_logic_vector(1 downto 0);
      o_Branch        : out std_logic;
      o_Alu_Src       : out std_logic;
      o_ext_ctl       : out std_logic;
      o_Jump          : out std_logic;
      o_jr            : out std_logic;
      o_jal           : out std_logic
    );
  end component;

  -- Inputs
  signal w_instruct31_26 : std_logic_vector(5 downto 0) := (others => '0');
  signal w_instruct5_0   : std_logic_vector(5 downto 0) := (others => '0');

  -- Outputs
  signal w_ALU_Ctl  : std_logic_vector(3 downto 0);
  signal w_RegWrite : std_logic;
  signal w_MemtoReg : std_logic;
  signal w_MemWrite : std_logic;
  signal w_MemRead  : std_logic;
  signal w_RegDst   : std_logic_vector(1 downto 0);
  signal w_Branch   : std_logic;
  signal w_Alu_Src  : std_logic;
  signal w_ext_ctl  : std_logic;
  signal w_Jump     : std_logic;
  signal w_jr       : std_logic;
  signal w_jal      : std_logic;

begin
  -- Instantiate the Unit Under Test (UUT)
  uut: Controller
    port map (
      i_instruct31_26 => w_instruct31_26,
      i_instruct5_0   => w_instruct5_0,
      o_Alu_Src       => w_Alu_Src,
      o_ALU_Ctl       => w_ALU_Ctl,
      o_MemtoReg      => w_MemtoReg,
      o_MemWrite      => w_MemWrite,
      o_RegWrite      => w_RegWrite,
      o_RegDst        => w_RegDst,
      o_Jump          => w_Jump,
      o_Branch        => w_Branch,
      o_MemRead       => w_MemRead,
      o_ext_ctl       => w_ext_ctl,
      o_jal           => w_jal,
      o_jr            => w_jr
    );

  -- Stimulus process

  stim_proc: process
  begin
    -- Apply test vectors
    wait for 10 ns;
    w_instruct31_26 <= "000000"; -- must be zero
    w_instruct5_0 <= "001010"; -- slti
    wait for 10 ns;

    wait for 10 ns;
    w_instruct31_26 <= "100100"; -- and 
    w_instruct5_0 <= "101111"; -- should be ignored
    wait for 10 ns;

    wait for 10 ns;
    w_instruct31_26 <= "000000"; -- must be zero
    w_instruct5_0 <= "001010"; -- slti
    wait for 10 ns;

    wait for 10 ns;
    w_instruct31_26 <= "000000"; -- must be zero
    w_instruct5_0 <= "101011"; -- Sw
    wait for 10 ns;

    wait;
  end process;
end architecture;
