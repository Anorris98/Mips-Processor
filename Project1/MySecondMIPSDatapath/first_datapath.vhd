-- first_datapath.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
    generic (N : integer := 32);
    port (
        i_CLK : in std_logic; -- Clock input
        i_RST : in std_logic; -- Reset input
        i_WE : in std_logic; -- Write enable input
        i_C : in std_logic; -- Add/Sub control
        i_ALU : in std_logic; -- ALU control
        i_rs_addrs : in std_logic_vector(4 downto 0); --rs address
        i_rt_addrs : in std_logic_vector(4 downto 0); --rt address
        i_rd_addrs : in std_logic_vector(4 downto 0); --rd address
        i_Imm : in std_logic_vector(N - 1 downto 0); --Immediate value
        o_C : out std_logic; -- Carry out bit
        o_Sum : out std_logic_vector(N - 1 downto 0) -- Sum out 32 bits
    );
end datapath;

architecture structural of datapath is
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

    component AddSub_N is
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

    -- Signal returned from ALU mux
    signal w_mux_rtn : std_logic_vector(N - 1 downto 0);
    -- t2 + t3
    signal w_t2_p_t3 : std_logic_vector(N - 1 downto 0);
    -- rs data
    signal w_rs_data : std_logic_vector(N - 1 downto 0);
    -- rt data
    signal w_rt_data : std_logic_vector(N - 1 downto 0);

begin
    regi : reg port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE => i_WE,
        i_rs_addrs => i_rs_addrs,
        i_rt_addrs => i_rt_addrs,
        i_rd_addrs => i_rd_addrs,
        i_rd_data => w_t2_p_t3,
        o_rs_data => w_rs_data,
        o_rt_data => w_rt_data);

    mux : mux2t1_N port map(
        i_S => i_ALU,
        i_D0 => w_rs_data,
        i_D1 => i_Imm,
        o_O => w_mux_rtn);

    addsub : AddSub_N port map(
        iC => i_C,
        iA => w_rt_data,
        iB => w_mux_rtn,
        oC => o_C,
        oS => w_t2_p_t3);

    o_Sum <= w_t2_p_t3;

end structural;