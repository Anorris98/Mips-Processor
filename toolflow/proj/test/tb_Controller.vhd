library IEEE;
  use IEEE.std_logic_1164.all;

entity tb_Controller is
  -- Testbench has no ports
end entity;

architecture behavior of tb_Controller is
  -- Component Declaration for the Unit Under Test (UUT)
  component Controller
  port (i_instruct31_26 : in  std_logic_vector(5 downto 0);
        i_instruct5_0   : in  std_logic_vector(5 downto 0);
        o_beq         : out std_logic;
        o_halt        : out std_logic;
        o_STD_SHIFT   : out std_logic;  -- Standard shift (1)we are doing a normal shift (0) we are doing a variable shift or does not matter.
        o_ALU_Ctl     : out std_logic_vector(5 downto 0);
        o_RegWrite    : out std_logic;
        o_MemtoReg    : out std_logic_vector(1 downto 0);
        o_MemWrite    : out std_logic;
        o_RegDst      : out std_logic_vector(1 downto 0);
        o_Branch      : out std_logic;
        o_Alu_Src     : out std_logic;
        o_ext_ctl     : out std_logic;
        o_Jump        : out std_logic;
        o_jr          : out std_logic;
        o_jal         : out std_logic
    );
  end component;

  -- Inputs
  signal w_instruct31_26 : std_logic_vector(5 downto 0) := (others => '0');
  signal w_instruct5_0   : std_logic_vector(5 downto 0) := (others => '0');

  -- Outputs
  signal w_beq      : std_logic;
  signal w_halt     : std_logic;
  signal w_STD_SHIFT : std_logic;
  signal w_ALU_Ctl  : std_logic_vector(5 downto 0);
  signal w_RegWrite : std_logic;
  signal w_MemtoReg : std_logic_vector(1 downto 0);
  signal w_MemWrite : std_logic;
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
      o_beq           => w_beq,
      o_halt          => w_halt,
      o_STD_SHIFT     => w_STD_SHIFT,
      o_Alu_Src       => w_Alu_Src,
      o_ALU_Ctl       => w_ALU_Ctl,
      o_MemtoReg      => w_MemtoReg,
      o_MemWrite      => w_MemWrite,
      o_RegWrite      => w_RegWrite,
      o_RegDst        => w_RegDst,
      o_Jump          => w_Jump,
      o_Branch        => w_Branch,
      o_ext_ctl       => w_ext_ctl,
      o_jal           => w_jal,
      o_jr            => w_jr
    );

  -- Stimulus process

  stim_proc: process
  begin
    -- Apply test vectors R type
    wait for 10 ns;
    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "010100"; -- halt
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100000"; -- add
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100001"; -- addu
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100100"; -- and
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100111"; -- nor
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100110"; -- xor
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100101"; -- or
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "101010"; -- slt
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "000000"; -- sll
    wait for 10 ns;

    wait for 10 ns;
    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "000010"; -- srl
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "000011"; -- sra
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "000100"; -- sllv
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "000110"; -- srlv
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "000111"; -- srav
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100010"; -- sub
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "100011"; -- subu
    wait for 10 ns;

    w_instruct31_26 <= "000000"; -- must be 0
    w_instruct5_0 <= "001000"; -- jr
    wait for 10 ns;

-- i and j type instructions
    wait for 10 ns;
    w_instruct31_26 <= "001000"; -- addi
    w_instruct5_0 <= "101011"; -- -doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "001001"; -- addiu
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "001100"; -- andi
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "001111"; -- lui
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "100011"; -- lw
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "001110"; -- xori
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "001101"; -- ori
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "001010"; -- slti
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "101011"; -- sw
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "000100"; -- beq
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "000101"; -- bne
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "100000"; -- lb
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "100001"; -- lh
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "100100"; -- lbu
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "100101"; -- lhu
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "000010"; -- jump
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    w_instruct31_26 <= "000011"; -- jal
    w_instruct5_0 <= "101011"; -- doesnt matter
    wait for 10 ns;

    wait;
  end process;
end architecture;
