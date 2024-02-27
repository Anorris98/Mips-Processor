-- reg.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.my_package.all;
use IEEE.numeric_std.all;

entity reg is
    generic (N : integer := 32);
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
end reg;

architecture structural of reg is
    component dffg_N is
        port (
            i_CLK : in std_logic; -- Clock input
            i_RST : in std_logic; -- Reset input
            i_WE : in std_logic; -- Write enable input
            i_D : in std_logic_vector(N - 1 downto 0); -- Data value input
            o_Q : out std_logic_vector(N - 1 downto 0)); -- Data value output
    end component;

    component decoder5_32 is
        port (
            D_IN : in std_logic_vector(4 downto 0);
            F_OUT : out std_logic_vector(N - 1 downto 0)); -- Data value output
    end component;

    component mux32t1 is
        port (
            data : in t_bus_32x32;
            sel : in std_logic_vector(4 downto 0);
            o_O : out std_logic_vector(N - 1 downto 0));
    end component;

    component andg2 is
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);
    end component;

    signal CLK, reset : std_logic := '0';
    signal s_o0 : std_logic_vector(N - 1 downto 0);
    signal s_32Bus : t_bus_32x32;
    signal s_F_OUT : std_logic_vector(N - 1 downto 0);
    signal s_aOUT : std_logic_vector(N - 1 downto 0);

begin

    CLK <= i_CLK;

    decoder : decoder5_32 port map(
        D_IN => i_rd_addrs,
        F_OUT => s_F_OUT);
    
    s_aOUT(0) <= '0';
    G_ANDG2 : for i in 1 to 31 generate
    andg_i : andg2 port map(
        i_A => s_F_OUT(i),
        i_B => i_WE,
        o_F => s_aOUT(i));
    end generate G_ANDG2;

    dffg_0 : dffg_N port map(
        i_CLK => CLK,
        i_RST => '1',
        i_WE => '0',
        i_D => s_F_OUT,
        o_Q => s_32Bus(0));

    G_dffg_Nbit : for i in 1 to 31 generate
    dffg_i : dffg_N port map(
        i_CLK => CLK,
        i_RST => i_RST,
        i_WE => s_aOUT(i),
        i_D => i_rd_data,
        o_Q => s_32Bus(i));
    end generate G_dffg_Nbit;

    rt_bus : mux32t1 port map(
        data => s_32Bus,
        sel => i_rt_addrs,
        o_O => o_rt_data);

    rs_bus : mux32t1 port map(
        data => s_32Bus,
        sel => i_rs_addrs,
        o_O => o_rs_data);

end structural;