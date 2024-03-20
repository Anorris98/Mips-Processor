
library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp_N is
    generic (N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port (
        i_bits : in std_logic_vector(N - 1 downto 0);
        o_bits_inv : out std_logic_vector(N - 1 downto 0));

end onesComp_N;

architecture structural of onesComp_N is

    component invg is
        port (
            i_A : in std_logic;
            o_F : out std_logic);
    end component;

begin

    -- Instantiate N mux instances.
    G_NBit_onesComp : for i in 0 to N - 1 generate
        invi : invg port map(
            i_A => i_bits(i), -- ith instance's data 0 input hooked up to ith data 0 input.
            o_F => o_bits_inv(i)); -- ith instance's data 1 input hooked up to ith data 1 input.
    end generate G_NBit_onesComp;

end structural;