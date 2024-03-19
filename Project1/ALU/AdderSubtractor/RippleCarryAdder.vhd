-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- implimentaition of a N bit ripple carry adder.
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Entity Declaration
entity RippleCarryAdder is
    generic(N : integer := 32); -- Configurable bit width
    Port ( A       : in  std_logic_vector(N-1 downto 0);
           B       : in  std_logic_vector(N-1 downto 0);
           Sum     : out std_logic_vector(N-1 downto 0);
           Carry   : out std_logic; -- Final carry out
 --          Zero    : out std_logic; -- Indicates if Sum is zero
           Overflow: out std_logic); -- Indicates overflow condition
end RippleCarryAdder;

-- Architecture Definition
architecture Structural of RippleCarryAdder is

    -- Single Bit Adder Component
    component Adder is
        Port ( i_D0  : in  std_logic;
               i_D1  : in  std_logic;
               i_Cin : in  std_logic;
               o_S   : out std_logic;
               o_C   : out std_logic);
    end component;

    -- Intermediate Carry Signals
    signal carry_intermediate : std_logic_vector(N downto 0);

begin

    -- Generic Generate Statement for Full Adders
    Gen_Adders: for i in 0 to N-1 generate
        FullAdder: Adder port map(
            i_D0  => A(i),
            i_D1  => B(i),
            i_Cin => carry_intermediate(i),
            o_S   => Sum(i),
            o_C   => carry_intermediate(i+1)
        );
    end generate Gen_Adders;

    -- Initialize the first carry-in
    carry_intermediate(0) <= '0';

    -- Final Carry Out
    Carry <= carry_intermediate(N);

    -- Zero Detection
 --   Zero <= '1' when (Sum = (others => '0')) else '0';

    -- Overflow Detection
    -- Overflow occurs when the carry into the most significant bit does not equal the carry out of the most significant bit.
    Overflow <= carry_intermediate(N-1) xor carry_intermediate(N);

end Structural;


