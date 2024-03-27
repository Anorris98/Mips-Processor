
-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- implimentaition of an AdderSubtractor with a 1 bit selector 0=add, 1=subtract
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--Entity define-------------------------------------------------------------
entity AdderSubtractor is
  generic(N : integer := 32); -- Generic of type integer, initalized to 16 for safety
  Port (    i_AddSub_A             : in   std_logic_vector(N-1 downto 0);  --input1
            i_AddSub_B             : in   std_logic_vector(N-1 downto 0);  --input2
            i_AddSub_nAdd_Sub      : in   std_logic  := '0';               --selector for add or sub 0=add, 1=sub
            o_AddSub_Sum           : out  std_logic_vector(N-1 downto 0);  --Sum Output
            o_AddSub_Cout          : out  std_logic;  --Sum Output         --Carry, signals if there was an issue/overflow. 
            o_AddSub_Overflow      : out  std_logic;
            o_AddSub_Zero          : out  std_logic
      );
            

end AdderSubtractor;
--Entity define-------------------------------------------------------------

--Structural define---------------------------------------------------------
architecture Structural of AdderSubtractor is

--Component define----------------------------------------------------------

component OnesComplementor is
  generic(N : integer := 32);
  Port (i_D0    :   in  std_logic_vector(N-1 downto 0);
        o_O     :   out std_logic_vector(N-1 downto 0));
end component;

component RippleCarryAdder is
    generic(N : integer := 32); -- Configurable bit width
    Port ( A       : in  std_logic_vector(N-1 downto 0);
           B       : in  std_logic_vector(N-1 downto 0);
           Sum     : out std_logic_vector(N-1 downto 0);
           Carry   : out std_logic; -- Final carry out
--           Zero    : out std_logic; -- Indicates if Sum is zero
           Overflow: out std_logic); -- Indicates overflow condition
end component;

component mux2t1_N is
  generic(N : integer := 32); 
    Port (i_S   :   in std_logic;
          i_D0  :   in std_logic_vector(N-1 downto 0);
          i_D1  :   in std_logic_vector(N-1 downto 0);
          o_O   :   out std_logic_vector(N-1 downto 0));
end component;

component or_1 is
    Port (i_A   :   in std_logic;
          i_B   :   in std_logic;
          o_F   :   out std_logic);
end component;

component or_N is
    Port (i_A   :   in std_logic;
          i_B   :   in std_logic;
          o_Out   :   out std_logic);
end component;


--Signals
    -- interconnection wires
    signal w_C0toA0, w_A0toM0, w_M0toA1         : std_logic_vector(N-1 downto 0); --used for interconnection of components
    signal w_A1Carry, w_A0Carry, w_Zero         : std_logic;  --used only to see if there was a carry/error
    signal w_sum                                : std_logic_vector(N-1 downto 0);
    signal w_adder0Overflow, w_adder1Overflow   : std_logic;

    -- adder1 input B, Always '0b001'
    signal one_bit_extended : std_logic_vector(N-1 downto 0)  :=  (others => '0'); --should force everything to zero then add a '1' at the end.
  
    

begin

one_bit_extended <=  "00000000000000000000000000000001"; -- must be adjusted according to N, for some reason i cannot set this up to work with N.

  ---------------------------------------------------------------------------
  -- Level 0: Connections From Input
  ---------------------------------------------------------------------------
  
  mux0: mux2t1_N                 -- allows selection of 0(add), or 1(sub)
        generic map(N => N)
        Port map (    
                  i_D0  =>  iB,        --selector 0(add)
                  i_D1  =>  w_A0toM0,          --selector 1(sub)
                  i_S   =>  iC,
                  o_O   =>  w_M0toA1);

  adder1: RippleCarryAdder        --Adds A and B together, B is either 0(i_B) or is 1(the inverted +1 of i_B)
        generic map(N => N)
        Port map ( 
                  A     =>  iA,
                  B     =>  w_M0toA1,
                  Sum   =>  w_sum,
                  Carry =>  w_A1Carry,
 --                 Zero  =>  o_AddSub_Zero,
                  Overflow => w_adder1Overflow
                  );

      --assign w_zero when w_sum is all 0's, else w_zero is 0.
  w_Zero <= '1' when w_sum = (x"00000000") else '0';
  o_AddSub_Zero <= w_Zero;    --output hooked up to result.
  oS <= w_sum;      --sum hooked up to sum.


  Complementor0: OnesComplementor --inverts the bits from i_B, then sends it to Adder0
        generic map(N => N)
        Port map (
                  i_D0  =>  iB,
                  o_O   =>  w_C0toA0);
  ---------------------------------------------------------------------------
  -- Level 1: All inputs atleast one gate deep
  ---------------------------------------------------------------------------
  Or0: or_1                       --takes in one of 2 carry signals, either form adder 1 or adder 2.
        Port map (
                  i_A   =>  w_A1Carry,
                  i_B   =>  w_A0Carry,
                  o_F   =>  oC);

  Or1: or_1                       --takes in the two overflow signals, and lets us know if an overflow occured.
        Port map (
                  i_A   =>  w_adder0Overflow,
                  i_B   =>  w_adder1Overflow,
                  o_F   =>  o_AddSub_Overflow);
                  
  Adder0: RippleCarryAdder       --takes in inverted i_b, then adds the result with one bit extended ('1')
        generic map(N => N)
        Port map ( 
                  A     =>  w_C0toA0,
                  B     =>  one_bit_extended,
                  Sum   =>  w_A0toM0,
                  Carry =>  w_A0Carry,
 --                 Zero  =>  o_AddSub_Zero,
                  Overflow => w_adder0Overflow);
  ---------------------------------------------------------------------------
  -- Level 2: all inputs atleast 2 gates deep
  ---------------------------------------------------------------------------


end Structural;