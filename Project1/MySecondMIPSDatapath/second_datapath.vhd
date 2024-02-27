-- second_datapath.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity datapath2 is
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
end datapath2;

architecture structural of datapath2 is
    component reg is
        port (
            i_CLK : in std_logic; -- Clock input
            i_RST : in std_logic; -- Reset input
            i_WE : in std_logic; -- Write enable input
            i_rs_addrs : in std_logic_vector(4 downto 0); -- addresss for rs
            i_rt_addrs : in std_logic_vector(4 downto 0); -- addresss for rt
            i_rd_addrs : in std_logic_vector(4 downto 0); -- addresss for rd
            i_rd_data : in std_logic_vector(N - 1 downto 0); -- data for rd
            o_rs_data : out std_logic_vector(N - 1 downto 0); -- data from rs
            o_rt_data : out std_logic_vector(N - 1 downto 0) -- data from rt
        );
    end component;

    component add_sub_N is
        port (
            iC : in std_logic;
            iA : in std_logic_vector(N - 1 downto 0);
            iB : in std_logic_vector(N - 1 downto 0);
            oC : out std_logic;
            oS : out std_logic_vector(N - 1 downto 0));
    end component;

    component mux2t1_N is
        port (
            i_S : in std_logic;
            i_D0 : in std_logic_vector(N - 1 downto 0);
            i_D1 : in std_logic_vector(N - 1 downto 0);
            o_O : out std_logic_vector(N - 1 downto 0));
    end component;

    component mem is
        generic (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10);

        port (
            clk : in std_logic;
            addr : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
            data : in std_logic_vector((DATA_WIDTH - 1) downto 0);
            we : in std_logic := '1';
            q : out std_logic_vector((DATA_WIDTH - 1) downto 0));
    end component;

    component extender16t32 is
        port (
            i_Imm16 : in std_logic_vector(15 downto 0);
            i_ctl : in std_logic;
            o_Imm32 : out std_logic_vector(31 downto 0));
    end component;

    -- Signal returned from ALU mux
    signal w_mux_alu_rtn : std_logic_vector(N - 1 downto 0);
    -- Signal returned from reg mux
    signal w_mux_reg_rtn : std_logic_vector(N - 1 downto 0);
    -- Add/Sub output
    signal w_adsb_o : std_logic_vector(N - 1 downto 0);
    -- rs data
    signal w_rs_data : std_logic_vector(N - 1 downto 0);
    -- rt data
    signal w_rt_data : std_logic_vector(N - 1 downto 0);
    -- memory output
    signal w_mem_o : std_logic_vector(N - 1 downto 0);
    -- extender output
    signal w_ext_o : std_logic_vector(N - 1 downto 0);

begin
    regg : reg port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_reg_WE,
        i_rs_addrs => i_rs_addrs,
        i_rt_addrs => i_rt_addrs,
        i_rd_addrs => i_rd_addrs,
        i_rd_data => w_mux_reg_rtn,
        o_rs_data => w_rs_data,
        o_rt_data => w_rt_data);

    ALU_mux : mux2t1_N port map(
        i_S => i_ALU_C,
        i_D0 => w_rs_data,
        i_D1 => w_ext_o,
        o_O => w_mux_alu_rtn);

    reg_mux : mux2t1_N port map(
        i_S => i_ld_C,
        i_D0 => w_adsb_o,
        i_D1 => w_mem_o,
        o_O => w_mux_reg_rtn);

    addsub : add_sub_N port map(
        iC => i_adsb_C,
        iA => w_rt_data,
        iB => w_mux_alu_rtn,
        oC => o_C,
        oS => w_adsb_o);

    dmem : mem port map(
        clk => i_CLK,
        addr => w_adsb_o(11 downto 2),
        data => w_rs_data,
        we => i_mem_WE,
        q => w_mem_o);

    ext : extender16t32 port map(
        i_Imm16 => i_Imm,
        i_ctl => i_ext_C,
        o_Imm32 => w_ext_o);

    o_Sum <= w_adsb_o;

end structural;