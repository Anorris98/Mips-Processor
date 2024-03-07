library IEEE;
use IEEE.std_logic_1164.all;

entity tb_controlLogic is
    -- Testbench has no ports
end tb_controlLogic;

architecture behavior of tb_controlLogic is
    -- Component Declaration for the Unit Under Test (UUT)
    component controlLogic
        port (
            instruct31_26  : in std_logic_vector(5 downto 0);
            instruct5_0    : in std_logic_vector(5 downto 0);
            o_ALU_Ctl      : out std_logic_vector(8 downto 0);
            o_RegWrite     : out std_logic;
            o_MemtoReg     : out std_logic;
            o_MemWrite     : out std_logic;
            o_MemRead      : out std_logic;
            o_RegDst       : out std_logic_vector(1 downto 0);
            o_Branch       : out std_logic;
            o_Alu_Src      : out std_logic;
            o_ext_ctl      : out std_logic;
            o_Jump         : out std_logic;
            o_jr           : out std_logic;
            o_jal          : out std_logic
        );
    end component;

    -- Inputs
    signal instruct31_26 : std_logic_vector(5 downto 0) := (others => '0');
    signal instruct5_0   : std_logic_vector(5 downto 0) := (others => '0');

    -- Outputs
    signal o_ALU_Ctl     : std_logic_vector(8 downto 0);
    signal o_RegWrite    : std_logic;
    signal o_MemtoReg    : std_logic;
    signal o_MemWrite    : std_logic;
    signal o_MemRead     : std_logic;
    signal o_RegDst      : std_logic_vector(1 downto 0);
    signal o_Branch      : std_logic;
    signal o_Alu_Src     : std_logic;
    signal o_ext_ctl     : std_logic;
    signal o_Jump        : std_logic;
    signal o_jr          : std_logic;
    signal o_jal         : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: controlLogic
        port map (
            instruct31_26 => instruct31_26,
            instruct5_0   => instruct5_0,
            o_ALU_Ctl     => o_ALU_Ctl,
            o_RegWrite    => o_RegWrite,
            o_MemtoReg    => o_MemtoReg,
            o_MemWrite    => o_MemWrite,
            o_MemRead     => o_MemRead,
            o_RegDst      => o_RegDst,
            o_Branch      => o_Branch,
            o_Alu_Src     => o_Alu_Src,
            o_ext_ctl     => o_ext_ctl,
            o_Jump        => o_Jump,
            o_jr          => o_jr,
            o_jal         => o_jal
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply test vectors
        instruct31_26 <= "001001"; -- addi
        wait for 10 ns;

        instruct31_26 <= "001100"; -- andi
        wait for 10 ns;
        
        wait;
    end process;
end behavior;
