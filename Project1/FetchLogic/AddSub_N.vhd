-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- AddSub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide Adder
-- subtractor using structural VHDL.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity AddSub_N is
    generic (N : integer := 32);
    port (
        iC : in std_logic;
        iA : in std_logic_vector(N - 1 downto 0);
        iB : in std_logic_vector(N - 1 downto 0);
        oC : out std_logic;
        oS : out std_logic_vector(N - 1 downto 0));
end AddSub_N;

architecture structural of AddSub_N is
    component full_adder_N is
        generic (N : integer := 32);
        port (
            iC : in std_logic;
            iA : in std_logic_vector(N - 1 downto 0);
            iB : in std_logic_vector(N - 1 downto 0);
            oC : out std_logic;
            oS : out std_logic_vector(N - 1 downto 0));
    end component;

    component onesComp_N is
        generic (N : integer := 32);
        port (
            i_bits : in std_logic_vector(N - 1 downto 0);
            o_bits_inv : out std_logic_vector(N - 1 downto 0));
    end component;

    component mux2t1_N is
        generic (N : integer := 32);
        port (
            i_S : in std_logic;
            i_D0 : in std_logic_vector(N - 1 downto 0);
            i_D1 : in std_logic_vector(N - 1 downto 0);
            o_O : out std_logic_vector(N - 1 downto 0));
    end component;

    -- Signal to store ~iB(i)
    signal w_iB_inv : std_logic_vector(N - 1 downto 0);
    -- Signal to store mux2t1 output
    signal w_mux_o : std_logic_vector(N - 1 downto 0);

begin

    -- Instantiate N mux instances.
    onesComp : onesComp_N port map(
        i_bits => iB, -- ith instance's data 0 input hooked up to ith data 0 input.
        o_bits_inv => w_iB_inv); -- ith instance's data 1 input hooked up to ith data 1 input.

    -- Instantiate N mux instances.
    MUX : mux2t1_N port map(
        i_S => iC, -- All instances share the same select input.
        i_D0 => iB, -- ith instance's data 0 input hooked up to ith data 0 input.
        i_D1 => w_iB_inv, -- ith instance's data 1 input hooked up to ith data 1 input.
        o_O => w_mux_o); -- ith instance's data output hooked up to ith data output.

    full_adder : full_adder_N port map(
        iC => iC,
        iA => iA,
        iB => w_mux_o,
        oC => oC,
        oS => oS);

end structural;