-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- full_adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide full
-- adder using structural VHDL, generics, and generate statements.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_N is
    generic (N : integer := 32);
    port (
        iC : in std_logic;
        iA : in std_logic_vector(N - 1 downto 0);
        iB : in std_logic_vector(N - 1 downto 0);
        oC : out std_logic;
        oS : out std_logic_vector(N - 1 downto 0));
end full_adder_N;

architecture structural of full_adder_N is
    component full_adder is
        port (
            iC : in std_logic;
            iA : in std_logic;
            iB : in std_logic;
            oC : out std_logic;
            oS : out std_logic);
    end component;

    -- Signal to carry the carry between adders
    signal w_oC : std_logic_vector(N-1 downto 0);
begin

    -- LSB is always 0
    LSB_BIT_FULL_ADDER : full_adder port map(
        iC => iC,
        iA => iA(0),
        iB => iB(0),
        oC => w_oC(0),
        oS => oS(0));

    G_NBIT_FULL_ADDER : for i in 1 to N - 2 generate
        FULL_ADDERI : full_adder port map(
            iC => w_oC(i-1),
            iA => iA(i),
            iB => iB(i),
            oC => w_oC(i),
            oS => oS(i));
    end generate G_NBIT_FULL_ADDER;

    -- MSB is N-1
    MSB_BIT_FULL_ADDER : full_adder port map(
        iC => w_oC(N-2),
        iA => iA(N-1),
        iB => iB(N-1),
        oC => oC,
        oS => oS(N-1));
end structural;