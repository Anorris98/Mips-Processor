library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is

    port (
        iC : in std_logic;
        iA : in std_logic;
        iB : in std_logic;
        oC : out std_logic;
        oS : out std_logic);

end full_adder;

architecture structural of full_adder is

    component org2 is
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);
    end component;

    component xorg2 is
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);
    end component;

    component andg2 is
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);
    end component;

    --signal to store A XOR B
    signal a_xor_b : std_logic;
    --signal to store A AND B
    signal a_and_b : std_logic;
    --signal to store A AND C
    signal a_and_c : std_logic;
    --signal to store B AND C
    signal b_and_c : std_logic;
    --signal to store A AND B OR A AND C
    signal ab_or_ac : std_logic;

begin
    --------------------------------------------------
    -- Step 1: Get oS
    --------------------------------------------------
    xorAB : xorg2
    port map(
        i_A => iA,
        i_B => iB,
        o_F => a_xor_b);

    xorABC : xorg2
    port map(
        i_A => a_xor_b,
        i_B => iC,
        o_F => oS);

    --------------------------------------------------
    -- Step 2: Get oC
    --------------------------------------------------
    andAB : andg2
    port map(
        i_A => iA,
        i_B => iB,
        o_F => a_and_b);

    andAC : andg2
    port map(
        i_A => iA,
        i_B => iC,
        o_F => a_and_c);

    andBC : andg2
    port map(
        i_A => iB,
        i_B => iC,
        o_F => b_and_c);

    orAB_AC : org2
    port map(
        i_A => a_and_b,
        i_B => a_and_c,
        o_F => ab_or_ac);

    orAB_AC_BC : org2
    port map(
        i_A => ab_or_ac,
        i_B => b_and_c,
        o_F => oC);

end structural;