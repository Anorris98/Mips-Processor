-- tb_second_datapath.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_second_datapath is
    generic (gCLK_HPER : time := 50 ns);
end tb_second_datapath;

architecture behavior of tb_second_datapath is

    constant N : integer := 32;
    -- Calculate the clock period as twice the half-period
    constant cCLK_PER : time := gCLK_HPER * 2;
    component datapath2
        generic (N : integer := 32);
        port (
            i_CLK : in std_logic; -- Clock input
            i_RST : in std_logic; -- Reset input
            i_reg_WE : in std_logic; -- Write enable input for register
            i_mem_WE : in std_logic; -- Write enable input for memory
            i_adsb_C : in std_logic; -- Add/Sub control (0 for add, 1 for sub)
            i_ext_C : in std_logic; -- Bit extender control (0 for 0 ext, 1 for sign ext)
            i_ALU_C : in std_logic; -- ALU control (0 for reg, 1 for imm)
            i_ld_C : in std_logic; -- Selector to load data from add/sub or memory
            i_rs_addrs : in std_logic_vector(4 downto 0); --rs address
            i_rt_addrs : in std_logic_vector(4 downto 0); --rt address
            i_rd_addrs : in std_logic_vector(4 downto 0); --rd address
            i_Imm : in std_logic_vector(15 downto 0); --Immediate value
            o_C : out std_logic; -- Carry out bit
            o_Sum : out std_logic_vector(N - 1 downto 0) -- Sum out 32 bits
        );
    end component;

    -- Temporary signals to connect to the dff component.
    signal s_CLK, s_RST, s_reg_WE, s_mem_WE, s_i_adsb_C : std_logic;
    signal s_i_ext_C, s_i_ALU_C, s_i_ld_C, s_o_C : std_logic;
    signal s_i_rs_addrs, s_i_rt_addrs, s_i_rd_addrs : std_logic_vector(4 downto 0);
    signal s_i_Imm : std_logic_vector(15 downto 0);
    signal s_o_Sum : std_logic_vector(N - 1 downto 0);

begin

    DUT : datapath2
    generic map(N => N)
    port map (
        i_CLK => s_CLK, -- Clock input
        i_RST => s_RST, -- Reset input
        i_reg_WE => s_reg_WE, -- Write enable input for register
        i_mem_WE => s_mem_WE, -- Write enable input for memory
        i_adsb_C => s_i_adsb_C, -- Add/Sub control (0 for add, 1 for sub)
        i_ext_C => s_i_ext_C, -- Bit extender control (0 for 0 ext, 1 for sign ext)
        i_ALU_C => s_i_ALU_C, -- ALU control (0 for reg, 1 for imm)
        i_ld_C => s_i_ld_C, -- Selector to load data from add/sub (0) or memory(1)
        i_rs_addrs => s_i_rs_addrs, --rs address
        i_rt_addrs => s_i_rt_addrs, --rt address
        i_rd_addrs => s_i_rd_addrs, --rd address
        i_Imm => s_i_Imm, --Immediate value
        o_C => s_o_C, -- Carry out bit
        o_Sum => s_o_Sum -- Sum out 32 bits
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

    -----------------------------------------------
    -- Test bench
    ----------------------------------------------- 
    P_TB : process
    begin

        -------------------------------------------
        -- addi $25, $0, 0
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00000"; -- Not strictly necessary for addi
        s_i_rt_addrs <= b"11001"; -- $25
        s_i_rd_addrs <= b"11001"; -- $25
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- addi $26, $0, 256
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00000"; -- Not strictly necessary for addi
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11010"; -- $26
        s_i_Imm <= x"0100"; -- Imm = 256
        wait for cCLK_PER;
       
        -------------------------------------------
        -- lw $1, 0($25)
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"11001"; -- $25
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"00001"; -- $1
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- lw $2, 4($25)
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"11001"; -- $25
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"00010"; -- $2
        s_i_Imm <= x"0004"; -- Imm = 4
        wait for cCLK_PER;

        -------------------------------------------
        -- add $1, $1, $2 = -1+2=1
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00010"; -- $2
        s_i_rd_addrs <= b"00001"; -- $1
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- sw $1, 0($26)
        -------------------------------------------
        s_reg_WE <= '0';
        s_mem_WE <= '1';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11010"; -- $26
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- lw $2, 8($25)
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"11001"; -- $25
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"00010"; -- $2
        s_i_Imm <= x"0008"; -- Imm = 8
        wait for cCLK_PER;

        -------------------------------------------
        -- add $1, $1, $2 = 1+-3=-2
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00010"; -- $2
        s_i_rd_addrs <= b"00001"; -- $1
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- sw $1, 4($26)
        -------------------------------------------
        s_reg_WE <= '0';
        s_mem_WE <= '1';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11010"; -- $26
        s_i_Imm <= x"0004"; -- Imm = 4
        wait for cCLK_PER;

        -------------------------------------------
        -- lw $2, 12($25)
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"11001"; -- $25
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"00010"; -- $2
        s_i_Imm <= x"000c"; -- Imm = 12
        wait for cCLK_PER;

        -------------------------------------------
        -- add $1, $1, $2 = -2+4=2
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00010"; -- $2
        s_i_rd_addrs <= b"00001"; -- $1
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- sw $1, 8($26)
        -------------------------------------------
        s_reg_WE <= '0';
        s_mem_WE <= '1';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11010"; -- $26
        s_i_Imm <= x"0008"; -- Imm = 8
        wait for cCLK_PER;

        -------------------------------------------
        -- lw $2, 16($25)
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"11001"; -- $25
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"00010"; -- $2
        s_i_Imm <= x"0010"; -- Imm = 16
        wait for cCLK_PER;

        -------------------------------------------
        -- add $1, $1, $2 = 2+5=7
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00010"; -- $2
        s_i_rd_addrs <= b"00001"; -- $1
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- sw $1, 12($26)
        -------------------------------------------
        s_reg_WE <= '0';
        s_mem_WE <= '1';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11010"; -- $26
        s_i_Imm <= x"000c"; -- Imm = 12
        wait for cCLK_PER;

        -------------------------------------------
        -- lw $2, 20($25)
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"11001"; -- $25
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"00010"; -- $2
        s_i_Imm <= x"0014"; -- Imm = 20
        wait for cCLK_PER;

        -------------------------------------------
        -- add $1, $1, $2 = 7+6=13
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00010"; -- $2
        s_i_rd_addrs <= b"00001"; -- $1
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- sw $1, 16($26)
        -------------------------------------------
        s_reg_WE <= '0';
        s_mem_WE <= '1';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11010"; -- $26
        s_i_Imm <= x"0010"; -- Imm = 16
        wait for cCLK_PER;

        -------------------------------------------
        -- lw $2, 24($25)
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"11001"; -- $25
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"00010"; -- $2
        s_i_Imm <= x"0018"; -- Imm = 24
        wait for cCLK_PER;

        -------------------------------------------
        -- add $1, $1, $2 = 13+-7=6
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '0';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00010"; -- $2
        s_i_rd_addrs <= b"00001"; -- $1
        s_i_Imm <= x"0000"; -- Imm = 0
        wait for cCLK_PER;

        -------------------------------------------
        -- addi $27, $0, 512
        -------------------------------------------
        s_reg_WE <= '1';
        s_mem_WE <= '0';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '0';
        s_i_ALU_C <= '1';
        s_i_ld_C <= '0';
        s_i_rs_addrs <= b"00000"; -- $0
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11011"; -- $27
        s_i_Imm <= x"0200"; -- Imm = 512
        wait for cCLK_PER;

        -------------------------------------------
        -- sw $1, -4($27)
        -------------------------------------------
        s_reg_WE <= '0';
        s_mem_WE <= '1';
        s_i_adsb_C <= '0';
        s_i_ext_C <= '1'; -- sign extend
        s_i_ALU_C <= '1';
        s_i_ld_C <= '1';
        s_i_rs_addrs <= b"00001"; -- $1
        s_i_rt_addrs <= b"00000"; -- $0
        s_i_rd_addrs <= b"11011"; -- $21
        s_i_Imm <= x"FFFC"; -- Imm = -4
        wait for cCLK_PER;
        wait;
    end process;

end behavior;