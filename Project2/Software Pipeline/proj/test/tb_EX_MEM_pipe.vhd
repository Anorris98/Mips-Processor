-- Drew Kearns
-- tb_EX_MEM_pipe.vhd
-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_EX_MEM_pipe is
    generic (gCLK_HPER : time := 50 ns);
end tb_EX_MEM_pipe;

architecture behavior of tb_EX_MEM_pipe is

    constant N : integer := 32;
    -- Component Declaration for the Unit Under Test (UUT)
    constant cCLK_PER : time := gCLK_HPER * 2;
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
            ------------------------------------------------------------------------------------
            -- outputs
            ------------------------------------------------------------------------------------
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

    --Inputs
    signal s_CLK           : std_logic;                        -- Clock input
    signal s_RST           : std_logic;                        -- Reset input
    signal s_WE            : std_logic;                        -- Write enable
    signal s_FLUSH         : std_logic;                        -- FLUSH
    signal s_EX_halt       : std_logic;                        -- Halt control signal
    signal s_EX_MemToReg   : std_logic_vector(1 downto 0);     -- MemToReg control signal
    signal s_EX_MemWrite   : std_logic;                        -- Memory write control signal
    signal s_EX_RegWrite   : std_logic;                        -- Register write control signal
    signal s_EX_Jump       : std_logic;                        -- Jump control signal
    signal s_EX_ext_ctl    : std_logic;                        -- Sign extension control signal
    signal s_EX_jal        : std_logic;                        -- Jump and link write back control signal
    signal s_EX_jr         : std_logic;                        -- Jump return control signal
    signal s_EX_branch     : std_logic;                        -- Branch output from ALU
    signal s_EX_PCP4       : std_logic_vector(N - 1 downto 0); -- PC+4 value
    signal s_EX_rs_data_o  : std_logic_vector(N - 1 downto 0); -- Output from Rs address
    signal s_EX_rt_data_o  : std_logic_vector(N - 1 downto 0); -- Output from Rt address
    signal s_EX_pc4_s120_o : std_logic_vector(N - 1 downto 0); -- Jump address
    signal s_EX_RegWrAddr  : std_logic_vector(4 downto 0);     -- Write address
    signal s_EX_Dmem_Addr  : std_logic_vector(N - 1 downto 0); -- Output from the ALU
    signal s_EX_add1_mux2  : std_logic_vector(N - 1 downto 0); -- Output from Adder 1

    --Outputs
    signal s_MEM_halt       : std_logic;                        -- Halt control signal
    signal s_MEM_MemToReg   : std_logic_vector(1 downto 0);     -- MemToReg control signal
    signal s_MEM_MemWrite   : std_logic;                        -- Memory write control signal
    signal s_MEM_RegWrite   : std_logic;                        -- Register write control signal
    signal s_MEM_Jump       : std_logic;                        -- Jump control signal
    signal s_MEM_ext_ctl    : std_logic;                        -- Sign extension control signal
    signal s_MEM_jal        : std_logic;                        -- Jump and link write back control signal
    signal s_MEM_jr         : std_logic;                        -- Jump return control signal
    signal s_MEM_branch     : std_logic;                        -- Branch output from ALU
    signal s_MEM_PCP4       : std_logic_vector(N - 1 downto 0); -- PC+4 value
    signal s_MEM_rs_data_o  : std_logic_vector(N - 1 downto 0); -- Output from Rs address
    signal s_MEM_rt_data_o  : std_logic_vector(N - 1 downto 0); -- Output from Rt address
    signal s_MEM_pc4_s120_o : std_logic_vector(N - 1 downto 0); -- Jump address
    signal s_MEM_RegWrAddr  : std_logic_vector(4 downto 0);     -- Write address
    signal s_MEM_Dmem_Addr  : std_logic_vector(N - 1 downto 0); -- Output from the ALU
    signal s_MEM_add1_mux2  : std_logic_vector(N - 1 downto 0); -- Output from Adder 1

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : EX_MEM_pipe
    generic map(N => N)
    port map(
        i_CLK           => s_CLK,           -- Clock input
        i_RST           => s_RST,           -- Reset input
        i_WE            => s_WE,            -- Write enable
        i_FLUSH         => s_FLUSH,         -- FLUSH
        i_EX_halt       => s_EX_halt,       -- Halt control signal
        i_EX_MemToReg   => s_EX_MemToReg,   -- MemToReg control signal
        i_EX_MemWrite   => s_EX_MemWrite,   -- Memory write control signal
        i_EX_RegWrite   => s_EX_RegWrite,   -- Register write control signal
        i_EX_Jump       => s_EX_Jump,       -- Jump control signal
        i_EX_ext_ctl    => s_EX_ext_ctl,    -- Sign extension control signal
        i_EX_jal        => s_EX_jal,        -- Jump and link write back control signal
        i_EX_jr         => s_EX_jr,         -- Jump return control signal
        i_EX_branch     => s_EX_branch,     -- Branch output from ALU
        i_EX_PCP4       => s_EX_PCP4,       -- PC+4 value
        i_EX_rs_data_o  => s_EX_rs_data_o,  -- Output from Rs address
        i_EX_rt_data_o  => s_EX_rt_data_o,  -- Output from Rt address
        i_EX_pc4_s120_o => s_EX_pc4_s120_o, -- Jump address
        i_EX_RegWrAddr  => s_EX_RegWrAddr,  -- Write address
        i_EX_Dmem_Addr  => s_EX_Dmem_Addr,  -- Output from the ALU
        i_EX_add1_mux2  => s_EX_add1_mux2,  -- Output from Adder 1
        ------------------------------------------------------------------------------------
        -- outputs
        ------------------------------------------------------------------------------------
        o_MEM_halt       => s_MEM_halt,       -- Halt control signal
        o_MEM_MemToReg   => s_MEM_MemToReg,   -- MemToReg control signal
        o_MEM_MemWrite   => s_MEM_MemWrite,   -- Memory write control signal
        o_MEM_RegWrite   => s_MEM_RegWrite,   -- Register write control signal
        o_MEM_Jump       => s_MEM_Jump,       -- Jump control signal
        o_MEM_ext_ctl    => s_MEM_ext_ctl,    -- Sign extension control signal
        o_MEM_jal        => s_MEM_jal,        -- Jump and link write back control signal
        o_MEM_jr         => s_MEM_jr,         -- Jump return control signal
        o_MEM_branch     => s_MEM_branch,     -- Branch output from ALU
        o_MEM_PCP4       => s_MEM_PCP4,       -- PC+4 value
        o_MEM_rs_data_o  => s_MEM_rs_data_o,  -- Output from Rs address
        o_MEM_rt_data_o  => s_MEM_rt_data_o,  -- Output from Rt address
        o_MEM_pc4_s120_o => s_MEM_pc4_s120_o, -- Jump address
        o_MEM_RegWrAddr  => s_MEM_RegWrAddr,  -- Write address
        o_MEM_Dmem_Addr  => s_MEM_Dmem_Addr,  -- Output from the ALU
        o_MEM_add1_mux2  => s_MEM_add1_mux2   -- Output from Adder 1
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
        s_WE            <= '1';
        s_FLUSH         <= '0';
        s_EX_halt       <= '1';
        s_EX_MemToReg   <= b"11";
        s_EX_MemWrite   <= '1';
        s_EX_RegWrite   <= '1';
        s_EX_Jump       <= '1';
        s_EX_ext_ctl    <= '1';
        s_EX_jal        <= '1';
        s_EX_jr         <= '1';
        s_EX_branch     <= '1';
        s_EX_PCP4       <= x"00400008";
        s_EX_rs_data_o  <= x"FFFFFFFF";
        s_EX_rt_data_o  <= x"FFFFFFFF";
        s_EX_pc4_s120_o <= x"FFFFFFFF";
        s_EX_RegWrAddr  <= b"11111";
        s_EX_Dmem_Addr  <= x"FFFFFFFF";
        s_EX_add1_mux2  <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_WE            <= '1';
        s_FLUSH         <= '0';
        s_EX_halt       <= '0';
        s_EX_MemToReg   <= b"00";
        s_EX_MemWrite   <= '0';
        s_EX_RegWrite   <= '0';
        s_EX_Jump       <= '0';
        s_EX_ext_ctl    <= '0';
        s_EX_jal        <= '0';
        s_EX_jr         <= '0';
        s_EX_branch     <= '0';
        s_EX_PCP4       <= x"00000000";
        s_EX_rs_data_o  <= x"00000000";
        s_EX_rt_data_o  <= x"00000000";
        s_EX_pc4_s120_o <= x"00000000";
        s_EX_RegWrAddr  <= b"00000";
        s_EX_Dmem_Addr  <= x"00000000";
        s_EX_add1_mux2  <= x"00000000";
        wait for cCLK_PER;

        s_WE            <= '0';
        s_FLUSH         <= '0';
        s_EX_halt       <= '1';
        s_EX_MemToReg   <= b"11";
        s_EX_MemWrite   <= '1';
        s_EX_RegWrite   <= '1';
        s_EX_Jump       <= '1';
        s_EX_ext_ctl    <= '1';
        s_EX_jal        <= '1';
        s_EX_jr         <= '1';
        s_EX_branch     <= '1';
        s_EX_PCP4       <= x"00400008";
        s_EX_rs_data_o  <= x"FFFFFFFF";
        s_EX_rt_data_o  <= x"FFFFFFFF";
        s_EX_pc4_s120_o <= x"FFFFFFFF";
        s_EX_RegWrAddr  <= b"11111";
        s_EX_Dmem_Addr  <= x"FFFFFFFF";
        s_EX_add1_mux2  <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_WE            <= '0';
        s_FLUSH         <= '0';
        s_EX_halt       <= '0';
        s_EX_MemToReg   <= b"00";
        s_EX_MemWrite   <= '0';
        s_EX_RegWrite   <= '0';
        s_EX_Jump       <= '0';
        s_EX_ext_ctl    <= '0';
        s_EX_jal        <= '0';
        s_EX_jr         <= '0';
        s_EX_branch     <= '0';
        s_EX_PCP4       <= x"00000000";
        s_EX_rs_data_o  <= x"00000000";
        s_EX_rt_data_o  <= x"00000000";
        s_EX_pc4_s120_o <= x"00000000";
        s_EX_RegWrAddr  <= b"00000";
        s_EX_Dmem_Addr  <= x"00000000";
        s_EX_add1_mux2  <= x"00000000";
        wait for cCLK_PER;

        s_WE            <= '1';
        s_FLUSH         <= '0';
        s_EX_halt       <= '1';
        s_EX_MemToReg   <= b"11";
        s_EX_MemWrite   <= '1';
        s_EX_RegWrite   <= '1';
        s_EX_Jump       <= '1';
        s_EX_ext_ctl    <= '1';
        s_EX_jal        <= '1';
        s_EX_jr         <= '1';
        s_EX_branch     <= '1';
        s_EX_PCP4       <= x"00400008";
        s_EX_rs_data_o  <= x"FFFFFFFF";
        s_EX_rt_data_o  <= x"FFFFFFFF";
        s_EX_pc4_s120_o <= x"FFFFFFFF";
        s_EX_RegWrAddr  <= b"11111";
        s_EX_Dmem_Addr  <= x"FFFFFFFF";
        s_EX_add1_mux2  <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_WE            <= '1';
        s_FLUSH         <= '1';
        s_EX_halt       <= '1';
        s_EX_MemToReg   <= b"11";
        s_EX_MemWrite   <= '1';
        s_EX_RegWrite   <= '1';
        s_EX_Jump       <= '1';
        s_EX_ext_ctl    <= '1';
        s_EX_jal        <= '1';
        s_EX_jr         <= '1';
        s_EX_branch     <= '1';
        s_EX_PCP4       <= x"00400008";
        s_EX_rs_data_o  <= x"FFFFFFFF";
        s_EX_rt_data_o  <= x"FFFFFFFF";
        s_EX_pc4_s120_o <= x"FFFFFFFF";
        s_EX_RegWrAddr  <= b"11111";
        s_EX_Dmem_Addr  <= x"FFFFFFFF";
        s_EX_add1_mux2  <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_WE            <= '1';
        s_FLUSH         <= '0';
        s_EX_halt       <= '1';
        s_EX_MemToReg   <= b"11";
        s_EX_MemWrite   <= '1';
        s_EX_RegWrite   <= '1';
        s_EX_Jump       <= '1';
        s_EX_ext_ctl    <= '1';
        s_EX_jal        <= '1';
        s_EX_jr         <= '1';
        s_EX_branch     <= '1';
        s_EX_PCP4       <= x"00400008";
        s_EX_rs_data_o  <= x"FFFFFFFF";
        s_EX_rt_data_o  <= x"FFFFFFFF";
        s_EX_pc4_s120_o <= x"FFFFFFFF";
        s_EX_RegWrAddr  <= b"11111";
        s_EX_Dmem_Addr  <= x"FFFFFFFF";
        s_EX_add1_mux2  <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_WE            <= '0';
        s_FLUSH         <= '1';
        s_EX_halt       <= '1';
        s_EX_MemToReg   <= b"11";
        s_EX_MemWrite   <= '1';
        s_EX_RegWrite   <= '1';
        s_EX_Jump       <= '1';
        s_EX_ext_ctl    <= '1';
        s_EX_jal        <= '1';
        s_EX_jr         <= '1';
        s_EX_branch     <= '1';
        s_EX_PCP4       <= x"00400008";
        s_EX_rs_data_o  <= x"FFFFFFFF";
        s_EX_rt_data_o  <= x"FFFFFFFF";
        s_EX_pc4_s120_o <= x"FFFFFFFF";
        s_EX_RegWrAddr  <= b"11111";
        s_EX_Dmem_Addr  <= x"FFFFFFFF";
        s_EX_add1_mux2  <= x"FFFFFFFF";
        wait for cCLK_PER;

        wait;
    end process;

end behavior;