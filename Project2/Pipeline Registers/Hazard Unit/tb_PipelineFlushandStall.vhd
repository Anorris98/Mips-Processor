-- Alek Norris
-- tb_PipelineFlushandStall.vhd
-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_PipelineFlushandStall is
    generic (gCLK_HPER : time := 50 ns);
end tb_PipelineFlushandStall;

architecture behavior of tb_PipelineFlushandStall is

    constant N : integer := 32;
    -- Component Declaration for the Unit Under Test (UUT)
    constant cCLK_PER : time := gCLK_HPER * 2;
    component IF_ID_pipe
        generic (N : integer := 32);
        port (
            i_CLK          : in std_logic;                         -- Clock input
            i_RST          : in std_logic;                         -- Reset input
            i_WE           : in std_logic;                         -- Write enable (1 when writing, 0 when stalling)
            i_FLUSH        : in std_logic;                         -- FLUSH
            i_IF_PC_P4     : in std_logic_vector(N - 1 downto 0);  -- PC + 4
            i_IF_instr31t0 : in std_logic_vector(N - 1 downto 0);  -- Entire instruction
            o_ID_PC_P4     : out std_logic_vector(N - 1 downto 0); -- PC + 4
            o_ID_instr31t0 : out std_logic_vector(N - 1 downto 0)  -- Entire instruction
        );
    end component;

    component ID_EX_pipe
     generic (N : integer := 32);
    port (
        i_CLK            : in std_logic;                        -- Clock input
        i_RST            : in std_logic;                        -- Reset input
        i_WE             : in std_logic;                        -- Write enable (1 when writing, 0 when stalling)
        i_FLUSH          : in std_logic;                        -- FLUSH
        i_ID_halt        : in std_logic;                        -- Halt control signal
        i_ID_STD_Shift   : in std_logic;                        -- STD Shift control signal
        i_ID_ALU_Src     : in std_logic;                        -- ALU Source control signal
        i_ID_ALU_Control : in std_logic_vector(7 downto 0);     -- ALU Control signals
        i_ID_MemToReg    : in std_logic_vector(1 downto 0);     -- MemToReg control signal
        i_ID_MemWrite    : in std_logic;                        -- Memory write control signal
        i_ID_RegWrite    : in std_logic;                        -- Register write control signal
        i_ID_RegDst      : in std_logic_vector(1 downto 0);     -- Register destination control signal
        i_ID_Jump        : in std_logic;                        -- Jump control signal
        i_ID_ext_ctl     : in std_logic;                        -- Sign extension control signal
        i_ID_jal         : in std_logic;                        -- Jump and link write back control signal
        i_ID_jr          : in std_logic;                        -- Jump return control signal
        i_ID_PCP4        : in std_logic_vector(N - 1 downto 0); -- PC+4 value
        i_ID_instr20t16  : in std_logic_vector(4 downto 0);     -- Register Rt address signal
        i_ID_instr15t11  : in std_logic_vector(4 downto 0);     -- Register Rd address signal
        i_ID_rs_data_o   : in std_logic_vector(N - 1 downto 0); -- Output from Rs address
        i_ID_rt_data_o   : in std_logic_vector(N - 1 downto 0); -- Output from Rt address
        i_ID_ext_o       : in std_logic_vector(N - 1 downto 0); -- Extension control output
        i_ID_s120_o      : in std_logic_vector(27 downto 0);    -- Instruction [25:0] shifted left 2
        o_EX_halt        : out std_logic;                        -- Halt control signal
        o_EX_STD_Shift   : out std_logic;                        -- STD Shift control signal
        o_EX_ALU_Src     : out std_logic;                        -- ALU Source control signal
        o_EX_ALU_Control : out std_logic_vector(7 downto 0);     -- ALU Control signals
        o_EX_MemToReg    : out std_logic_vector(1 downto 0);     -- MemToReg control signal
        o_EX_MemWrite    : out std_logic;                        -- Memory write control signal
        o_EX_RegWrite    : out std_logic;                        -- Register write control signal
        o_EX_RegDst      : out std_logic_vector(1 downto 0);     -- Register destination control signal
        o_EX_Jump        : out std_logic;                        -- Jump control signal
        o_EX_ext_ctl     : out std_logic;                        -- Sign extension control signal
        o_EX_jal         : out std_logic;                        -- Jump and link write back control signal
        o_EX_jr          : out std_logic;                        -- Jump return control signal
        o_EX_PCP4        : out std_logic_vector(N - 1 downto 0); -- PC+4 value
        o_EX_instr20t16  : out std_logic_vector(4 downto 0);     -- Register Rt address signal
        o_EX_instr15t11  : out std_logic_vector(4 downto 0);     -- Register Rd address signal
        o_EX_rs_data_o   : out std_logic_vector(N - 1 downto 0); -- Output from Rs address
        o_EX_rt_data_o   : out std_logic_vector(N - 1 downto 0); -- Output from Rt address
        o_EX_ext_o       : out std_logic_vector(N - 1 downto 0); -- Extension control output
        o_EX_s120_o      : out std_logic_vector(27 downto 0)     -- Instruction [25:0] shifted left 2
    );
    end component;

    component EX_MEM_pipe
    generic (N : integer := 32);
    port (
     i_CLK           : in std_logic;                        -- Clock input
        i_RST           : in std_logic;                        -- Reset input
        i_WE            : in std_logic;                        -- Write enable (1 when writing, 0 when stalling)
        i_FLUSH         : in std_logic;                        -- FLUSH control
        i_EX_halt       : in std_logic;                        -- Halt control signal
        i_EX_MemToReg   : in std_logic_vector(1 downto 0);     -- MemToReg control signal
        i_EX_MemWrite   : in std_logic;                        -- Memory write control signal
        i_EX_RegWrite   : in std_logic;                        -- Register write control signal
        i_EX_Jump       : in std_logic;                        -- Jump control signal
        i_EX_ext_ctl    : in std_logic;                        -- Sign extension control signal
        i_EX_jal        : in std_logic;                        -- Jump and link write back control signal
        i_EX_jr         : in std_logic;                        -- Jump return control signal
        i_EX_branch     : in std_logic;                        -- Branch output from ALU
        i_EX_PCP4       : in std_logic_vector(N - 1 downto 0); -- PC+4 value
        i_EX_rs_data_o  : in std_logic_vector(N - 1 downto 0); -- Output from Rs address
        i_EX_rt_data_o  : in std_logic_vector(N - 1 downto 0); -- Output from Rt address
        i_EX_pc4_s120_o : in std_logic_vector(N - 1 downto 0); -- Jump address
        i_EX_RegWrAddr  : in std_logic_vector(4 downto 0);     -- Write address
        i_EX_Dmem_Addr  : in std_logic_vector(N - 1 downto 0); -- Output from the ALU
        i_EX_add1_mux2  : in std_logic_vector(N - 1 downto 0); -- Output from Adder 1
        o_MEM_halt       : out std_logic;                        -- Halt control signal
        o_MEM_MemToReg   : out std_logic_vector(1 downto 0);     -- MemToReg control signal
        o_MEM_MemWrite   : out std_logic;                        -- Memory write control signal
        o_MEM_RegWrite   : out std_logic;                        -- Register write control signal
        o_MEM_Jump       : out std_logic;                        -- Jump control signal
        o_MEM_ext_ctl    : out std_logic;                        -- Sign extension control signal
        o_MEM_jal        : out std_logic;                        -- Jump and link write back control signal
        o_MEM_jr         : out std_logic;                        -- Jump return control signal
        o_MEM_branch     : out std_logic;                        -- Branch output from ALU
        o_MEM_PCP4       : out std_logic_vector(N - 1 downto 0); -- PC+4 value
        o_MEM_rs_data_o  : out std_logic_vector(N - 1 downto 0); -- Output from Rs address
        o_MEM_rt_data_o  : out std_logic_vector(N - 1 downto 0); -- Output from Rt address
        o_MEM_pc4_s120_o : out std_logic_vector(N - 1 downto 0); -- Jump address
        o_MEM_RegWrAddr  : out std_logic_vector(4 downto 0);     -- Write address
        o_MEM_Dmem_Addr  : out std_logic_vector(N - 1 downto 0); -- Output from the ALU
        o_MEM_add1_mux2  : out std_logic_vector(N - 1 downto 0)  -- Output from Adder 1
    );
    end component;

    component MEM_WB_pipe
    generic (N : integer := 32);
    port (
        i_CLK           : in std_logic;                        -- Clock input
        i_RST           : in std_logic;                        -- Reset input
        i_WE            : in std_logic;                        -- Write enable
        i_MEM_halt      : in std_logic;                        -- Halt control signal
        i_MEM_MemToReg  : in std_logic_vector(1 downto 0);     -- MemToReg control signal
        i_MEM_RegWrite  : in std_logic;                        -- Register write control signal
        i_MEM_jal       : in std_logic;                        -- Jump and link write back control signal
        i_MEM_PCP4      : in std_logic_vector(N - 1 downto 0); -- PC+4 value
        i_MEM_RegWrAddr : in std_logic_vector(4 downto 0);     -- Write address
        i_MEM_Dmem_Addr : in std_logic_vector(N - 1 downto 0); -- Output from the ALU
        i_MEM_Dmem_out  : in std_logic_vector(N - 1 downto 0); -- Output from DMEM
        i_MEM_Dmem_Lb   : in std_logic_vector(N - 1 downto 0); -- Output from byte decoder
        i_MEM_Dmem_Lh   : in std_logic_vector(N - 1 downto 0); -- Output from word decoder
        o_WB_halt      : out std_logic;                        -- Halt control signal
        o_WB_MemToReg  : out std_logic_vector(1 downto 0);     -- MemToReg control signal
        o_WB_RegWrite  : out std_logic;                        -- Register write control signal
        o_WB_jal       : out std_logic;                        -- Jump and link write back control signal
        o_WB_PCP4      : out std_logic_vector(N - 1 downto 0); -- PC+4 value
        o_WB_RegWrAddr : out std_logic_vector(4 downto 0);     -- Write address
        o_WB_Dmem_Addr : out std_logic_vector(N - 1 downto 0); -- Output from the ALU
        o_WB_Dmem_out  : out std_logic_vector(N - 1 downto 0); -- Output from DMEM
        o_WB_Dmem_Lb   : out std_logic_vector(N - 1 downto 0); -- Output from byte decoder
        o_WB_Dmem_Lh   : out std_logic_vector(N - 1 downto 0)  -- Output from word decoder
    );
end component;




    --Inputs
    signal s_CLK          : std_logic;
    signal s_RST          : std_logic;
    signal s_WE           : std_logic;
    signal s_FLUSH        : std_logic;
    signal s_IF_PC_P4     : std_logic_vector(N - 1 downto 0);
    signal s_IF_instr31t0 : std_logic_vector(N - 1 downto 0);

  -- IF_ID
  signal d_IF_ID_Stall          : std_logic:= '0'; -- first set to zero because questasim didnt like it being undefined at start technically because of the not assignment.
  signal s_IF_ID_Stall          : std_logic;
  signal s_IF_ID_Jump           : std_logic;
  signal s_IF_ID_Reg_Write      : std_logic;
  signal s_IF_ID_Reg_Dst_Addr   : std_logic_vector(4 downto 0);

  -- ID_EX
  signal d_ID_EX_Stall          : std_logic:= '0';
  signal s_ID_EX_Stall          : std_logic;
  signal s_ID_EX_Jump           : std_logic;
  signal s_ID_EX_Reg_Write      : std_logic;
  signal s_ID_EX_Reg_Dst_Addr   : std_logic_vector(4 downto 0);

  -- EX_MEM
  signal d_EX_MEM_Stall         : std_logic:= '0';
  signal s_EX_MEM_Stall         : std_logic;
  signal s_EX_MEM_Jump          : std_logic;
  signal s_EX_MEM_Reg_Write     : std_logic;
  signal s_EX_MEM_Reg_Dst_Addr  : std_logic_vector(4 downto 0);

  -- MEM_WB
  signal d_MEM_WB_Stall         : std_logic:= '0';
  signal s_MEM_WB_Stall         : std_logic;
  signal s_MEM_WB_Jump          : std_logic;
  signal s_MEM_WB_Reg_Write     : std_logic;
  signal s_MEM_WB_Reg_Dst_Addr  : std_logic_vector(4 downto 0);
  signal s_WB_Reg_Dst_Addr      : std_logic_vector(4 downto 0);

    
    --Outputs
    signal s_ID_PC_P4     : std_logic_vector(N - 1 downto 0);
    signal s_ID_instr31t0 : std_logic_vector(N - 1 downto 0);

begin
s_IF_ID_Stall           <= d_IF_ID_Stall;                   -- I was using an older version compiler when i first started this and Had to do this weird work around to get it to compile, so i just left it.
s_ID_EX_Stall           <= d_ID_EX_Stall;
s_EX_MEM_Stall          <= d_EX_MEM_Stall;
s_MEM_WB_Stall          <= d_MEM_WB_Stall;



    -- Instantiate the Unit Under Test (UUT)
    uut0 : IF_ID_pipe
    generic map(N => N)
    port map(
        i_CLK          => s_CLK,
        i_RST          => s_RST,
        i_WE           => not s_IF_ID_Stall,
        i_FLUSH        => s_FLUSH,
        i_IF_PC_P4     => s_IF_PC_P4,
        i_IF_instr31t0 => s_IF_instr31t0,
        o_ID_PC_P4     => s_ID_PC_P4,
        o_ID_instr31t0 => s_ID_instr31t0
    );
    

    uut1 : ID_EX_pipe
    generic map(N => N)
    port map(
        i_CLK            => s_CLK,              
        i_RST            => s_RST,              
        i_WE             => not s_IF_ID_Stall,      --push manually
        i_FLUSH          => s_FLUSH,      
        i_ID_halt        => '1',
        i_ID_STD_Shift   => '1',
        i_ID_ALU_Src     => '1',
        i_ID_ALU_Control => (others => '1'),
        i_ID_MemToReg    => (others => '1'),
        i_ID_MemWrite    => '1',
        i_ID_RegWrite    => s_IF_ID_Reg_Write,  --push manually
        i_ID_RegDst      => (others => '1'),    --push manually
        i_ID_Jump        => s_IF_ID_Jump,       --push manually
        i_ID_ext_ctl     => '1',
        i_ID_jal         => '1',
        i_ID_jr          => '1',
        i_ID_PCP4        => (others => '1'),
        i_ID_instr20t16  => (others => '1'),
        i_ID_instr15t11  => s_ID_instr31t0(15 downto 11),
        i_ID_rs_data_o   => (others => '1'),
        i_ID_rt_data_o   => (others => '1'),
        i_ID_ext_o       => (others => '1'),
        i_ID_s120_o      => (others => '1'),
        o_EX_halt        => open,
        o_EX_STD_Shift   => open,
        o_EX_ALU_Src     => open,
        o_EX_ALU_Control => open,
        o_EX_MemToReg    => open,
        o_EX_MemWrite    => open,
        o_EX_RegWrite    => s_ID_EX_Reg_Write,
        o_EX_RegDst      => open,
        o_EX_Jump        => s_ID_EX_Jump,
        o_EX_ext_ctl     => open,
        o_EX_jal         => open,
        o_EX_jr          => open,
        o_EX_PCP4        => open,
        o_EX_instr20t16  => open,
        o_EX_instr15t11  => s_ID_EX_Reg_Dst_Addr,
        o_EX_rs_data_o   => open,
        o_EX_rt_data_o   => open,
        o_EX_ext_o       => open,
        o_EX_s120_o      => open
    );

    uut2 : EX_MEM_pipe
    generic map(N => N)
    port map(
        i_CLK            => s_CLK,          
        i_RST            => s_RST,           
        i_WE             => not s_EX_MEM_Stall,
        i_FLUSH          => s_FLUSH,         
        i_EX_halt        => '1',
        i_EX_MemToReg    => (others => '1'),
        i_EX_MemWrite    => '1',
        i_EX_RegWrite    => s_ID_EX_Reg_Write,
        i_EX_Jump        => s_ID_EX_Jump,
        i_EX_ext_ctl     => '1',
        i_EX_jal         => '1',
        i_EX_jr          => '1',
        i_EX_branch      => '1',
        i_EX_PCP4        => (others => '1'),
        i_EX_rs_data_o   => (others => '1'),
        i_EX_rt_data_o   => (others => '1'),
        i_EX_pc4_s120_o  => (others => '1'),
        i_EX_RegWrAddr   => s_ID_EX_Reg_Dst_Addr,
        i_EX_Dmem_Addr   => (others => '1'),
        i_EX_add1_mux2   => (others => '1'),
        o_MEM_halt       => open,
        o_MEM_MemToReg   => open,
        o_MEM_MemWrite   => open,
        o_MEM_RegWrite   => s_EX_MEM_Reg_Write,
        o_MEM_Jump       => s_EX_MEM_Jump,
        o_MEM_ext_ctl    => open,
        o_MEM_jal        => open,
        o_MEM_jr         => open,
        o_MEM_branch     => open,
        o_MEM_PCP4       => open,
        o_MEM_rs_data_o  => open,
        o_MEM_rt_data_o  => open,
        o_MEM_pc4_s120_o => open,
        o_MEM_RegWrAddr  => s_EX_MEM_Reg_Dst_Addr,
        o_MEM_Dmem_Addr  => open,
        o_MEM_add1_mux2  => open
    );

    uut3 : MEM_WB_pipe
    generic map(N => N)
    port map(
        i_CLK           => s_CLK,
        i_RST           => s_RST,
        i_WE            => not s_MEM_WB_Stall,
        i_MEM_halt      => '1',
        i_MEM_MemToReg  => (others => '1'),
        i_MEM_RegWrite  => s_EX_MEM_Reg_Write,
        i_MEM_jal       => '1',     
        i_MEM_PCP4      => (others => '1'),
        i_MEM_RegWrAddr => s_EX_MEM_Reg_Dst_Addr,
        i_MEM_Dmem_Addr => (others => '1'),
        i_MEM_Dmem_out  => (others => '1'),
        i_MEM_Dmem_Lb   => (others => '1'),
        i_MEM_Dmem_Lh   => (others => '1'),
        o_WB_halt       => open,     
        o_WB_MemToReg   => open,   
        o_WB_RegWrite   => open,   
        o_WB_jal        => open,   
        o_WB_PCP4       => open,       
        o_WB_RegWrAddr  => s_WB_Reg_Dst_Addr,   
        o_WB_Dmem_Addr  => open,   
        o_WB_Dmem_out   => open,   
        o_WB_Dmem_Lb    => open,   
        o_WB_Dmem_Lh    => open   
    );





    -- This process sets the clock value (low for gCLK_HPER, then high
    -- for gCLK_HPER). Absent a "wait" command, processes restart 
    -- at the beginning once they have reached the final statement.
    P_CLK : process
    begin
        s_CLK <= '0';
        wait for gCLK_HPER;
        s_CLK <= '1';
        wait for gCLK_HPER;
    end process;

    -----------------------------------------------
    -- Reset data in the registers
    ----------------------------------------------- 
    P_RST : process
    begin
        s_RST <= '1';
        wait for cCLK_PER/2;
        s_RST <= '0';
        wait;
    end process;

    ----------------------------------
    -- Test bench
    ----------------------------------
    P_TB : process
    begin
        s_WE                <= '1';
        s_FLUSH             <= '0';
        s_IF_PC_P4          <= x"00400004";
        s_IF_instr31t0      <= x"11111111";
        d_IF_ID_Stall       <= '0';
        d_ID_EX_Stall       <= '0';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';

        
        wait for cCLK_PER;

        s_WE                    <= '1';
        s_FLUSH                 <= '0';
        s_IF_PC_P4              <= x"00400008";
        s_IF_instr31t0          <= x"22222222";
        d_IF_ID_Stall           <= '0';
        d_ID_EX_Stall           <= '0'; -- stall, so MEM/WB should not get new signals.
        d_EX_MEM_Stall          <= '0';
        d_MEM_WB_Stall          <= '0';
        s_IF_ID_Reg_Write       <= '0';  
        s_IF_ID_Reg_Dst_Addr    <= "10101";
        s_IF_ID_Jump            <= '0';
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400004"; -- should now get signals
        s_IF_instr31t0 <= x"11111111";
        d_IF_ID_Stall       <= '0';
        d_ID_EX_Stall       <= '0';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400008"; --stall all, should hold signal.
        s_IF_instr31t0 <= x"22222222";
        d_IF_ID_Stall       <= '0';
        d_ID_EX_Stall       <= '0';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '0';  
        s_IF_ID_Reg_Dst_Addr     <= "10101";
        s_IF_ID_Jump        <= '0';
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"0040000C"; --should clear all signals on clock edge to zero.
        s_IF_instr31t0 <= x"33333333";
        d_IF_ID_Stall       <= '0';
        d_ID_EX_Stall       <= '1';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400010"; --should load new values
        s_IF_instr31t0 <= x"44444444";
        d_IF_ID_Stall       <= '0';
        d_ID_EX_Stall       <= '1';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '0';  
        s_IF_ID_Reg_Dst_Addr     <= "10101";
        s_IF_ID_Jump        <= '0';
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400020"; --lload and work like normal.
        s_IF_instr31t0 <= x"99999999";
        d_IF_ID_Stall       <= '0';
        d_ID_EX_Stall       <= '0';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400014"; --should stall first two reg values and not third.
        s_IF_instr31t0 <= x"55555555";
        d_IF_ID_Stall       <= '1';
        d_ID_EX_Stall       <= '1';
        d_EX_MEM_Stall      <= '1';
        d_MEM_WB_Stall      <= '1';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';        
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '1'; -- Should flush regardless of write enable signal bit
        s_IF_PC_P4     <= x"00400014";
        s_IF_instr31t0 <= x"55555555";
        d_IF_ID_Stall       <= '1';
        d_ID_EX_Stall       <= '0';
        d_EX_MEM_Stall      <= '1';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';        
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400014";
        s_IF_instr31t0 <= x"66666666";
        d_IF_ID_Stall       <= '0';
        d_ID_EX_Stall       <= '0';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';        
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '0'; -- Should flush regardless of write enable signal bit
        s_IF_PC_P4     <= x"00400014"; --should stall and not load anything.
        s_IF_instr31t0 <= x"55555555";
        d_IF_ID_Stall       <= '1';
        d_ID_EX_Stall       <= '0';
        d_EX_MEM_Stall      <= '0';
        d_MEM_WB_Stall      <= '0';
        s_IF_ID_Reg_Write   <= '1';  
        s_IF_ID_Reg_Dst_Addr     <= "11111";
        s_IF_ID_Jump        <= '1';        
        wait for cCLK_PER;

        wait;
    end process;

end behavior;