-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- fetchLogic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide Adder
-- subtractor using structural VHDL.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fetchLogic is
    generic (N : integer := 32);
    port (
        iC : in std_logic;
        iA : in std_logic_vector(N - 1 downto 0);
        iB : in std_logic_vector(N - 1 downto 0);
        oC : out std_logic;
        oS : out std_logic_vector(N - 1 downto 0));
end fetchLogic;

architecture structural of fetchLogic is
    component AddSub_N is
        generic (N : integer := 32);
        port (
            iC : in std_logic;
            iA : in std_logic_vector(N - 1 downto 0);
            iB : in std_logic_vector(N - 1 downto 0);
            oC : out std_logic;
            oS : out std_logic_vector(N - 1 downto 0));
    end component;

    component mux2t1_N is
        generic (N : integer := 32);
        port (
            i_S : in std_logic;
            i_D0 : in std_logic_vector(N - 1 downto 0);
            i_D1 : in std_logic_vector(N - 1 downto 0);
            o_O : out std_logic_vector(N - 1 downto 0));
    end component;



begin


end structural;