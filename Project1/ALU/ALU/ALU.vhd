
-------------------------------------------------------------------------
-- @author Alek Norris
-- @Creation: 3/5/2024
-- Iowa State University
-- CPRE 381
-- Implimentation of a 32 bit ALU, does all operations, then a 8 to 1 mux selects what to output.
-- ALU.vhd
-------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.all;

entity ALU is
  generic (N : integer := 32);
<<<<<<< HEAD
  port (i_ALU_A               : in  std_logic_vector(N - 1 downto 0); -- ALU Input A
        i_ALU_B               : in  std_logic_vector(N - 1 downto 0); -- ALU Input B
        i_ALU_Ctl             : in  std_logic_vector(5 downto 0);     -- ALU Control Input [4]Signed or unsidned, [3]shift L or A, [2]selector, [1]selector, [0]selector
        o_ALU_Carry           : out std_logic;                        -- ALU Indicator for a carry out bit.
        o_ALU_Zero            : out std_logic;                        -- ALU Indicator that an operation has resulting in a 0 output.
        o_ALU_Overflow        : out std_logic;                        -- ALU Indicator that an overflow has occured.
        o_ALU_I_Result : out std_logic_vector(N - 1 downto 0));       -- ALU add Sub Results.
=======
  port (i_ALU_A        : in  std_logic_vector(N - 1 downto 0); -- ALU Input A
        i_ALU_B        : in  std_logic_vector(N - 1 downto 0); -- ALU Input B
        i_ALU_Ctl      : in  std_logic_vector(4 downto 0);     -- ALU Control Input [4]Signed or unsidned, [3]shift L or A, [2]selector, [1]selector, [0]selector
        o_ALU_Carry    : out std_logic;                        -- ALU Indicator for a carry out bit.
        o_ALU_Zero     : out std_logic;                        -- ALU Indicator that an operation has resulting in a 0 output.
        o_ALU_Overflow : out std_logic;                        -- ALU Indicator that an overflow has occured.
        o_ALU_I_Result : out std_logic_vector(N - 1 downto 0)); -- ALU add Sub Results.
>>>>>>> 0bf627cb05f496d5312db0b4442a7c81fdc31265
end entity;

architecture structure of ALU is

  component AdderSubtractor is
    generic (N : integer := 32);
    port (
      iC                : in  std_logic;
      iA                : in  std_logic_vector(N - 1 downto 0);
      iB                : in  std_logic_vector(N - 1 downto 0);
      oC                : out std_logic;
      oS                : out std_logic_vector(N - 1 downto 0);
      o_AddSub_Overflow : out std_logic;
      o_AddSub_Zero     : out std_logic);
  end component;

  component andg2
    port (i_A : in  std_logic;
          i_B : in  std_logic;
          o_F : out std_logic);
  end component;

  component org2
    port (i_A : in  std_logic;
          i_B : in  std_logic;
          o_F : out std_logic);
  end component;

  component andg_N
    generic (N : integer := 32);
    port (i_A   : in  std_logic_vector(N - 1 downto 0);
          i_B   : in  std_logic_vector(N - 1 downto 0);
          o_Out : out std_logic_vector(N - 1 downto 0));
  end component;

  component org_N
    generic (N : integer := 32);
    port (i_A   : in  std_logic_vector(N - 1 downto 0);
          i_B   : in  std_logic_vector(N - 1 downto 0);
          o_Out : out std_logic_vector(N - 1 downto 0));
  end component;

  component xorg_N
    generic (N : integer := 32);
    port (i_A   : in  std_logic_vector(N - 1 downto 0);
          i_B   : in  std_logic_vector(N - 1 downto 0);
          o_Out : out std_logic_vector(N - 1 downto 0));
  end component;

  component norg_N
    generic (N : integer := 32);
    port (i_A   : in  std_logic_vector(N - 1 downto 0);
          i_B   : in  std_logic_vector(N - 1 downto 0);
          o_Out : out std_logic_vector(N - 1 downto 0));
  end component;

  component Shifter
    generic (N : integer := 32);
    port (i_in        : in  std_logic_vector(N - 1 downto 0);
          i_shift_C   : in  std_logic; --0 = Logical, 1 = Arithmetic
          i_Direction : in  std_logic; --0 = left, 1 = right
          i_Shamt     : in  std_logic_vector(5 downto 0);
          o_Out       : out std_logic_vector(N - 1 downto 0));
  end component;

  component mux8t1_N
    generic (N : integer := 32);
    port (i_w0, i_w1, i_w2, i_w3 : in  std_logic_vector(N - 1 downto 0);
          i_w4, i_w5, i_w6, i_w7 : in  std_logic_vector(N - 1 downto 0);
          i_s0                   : in  std_logic;
          i_s1                   : in  std_logic;
          i_s2                   : in  std_logic;
          o_Y                    : out std_logic_vector(N - 1 downto 0));
  end component;

  -- Component Declarations
  -- Signals
  signal w_AND, w_OR, w_XOR, w_NOR, w_Shift, w_AddSub, w_Lui : std_logic_vector(N - 1 downto 0);
  signal w_OVERFLOW, w_SignedOrUnsigned                      : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: Direct Connections from Inputs
  ---------------------------------------------------------------------------
  w_Lui              <= i_ALU_B(15 downto 0) & x"0000"; -- LUI
  w_SignedOrUnsigned <= i_ALU_Ctl(4);                   -- (1)Signed, (0)Unsigned

  -- Adder/Subtractor Component
  addsub: AdderSubtractor
    port map (
      iC                => i_ALU_Ctl(3), --(0)Add, (1)subtract
      iA                => i_ALU_A,
      iB                => i_ALU_B,
      oC                => o_ALU_Carry,
      oS                => w_AddSub,
      o_AddSub_Overflow => w_OVERFLOW,
      o_AddSub_Zero     => o_ALU_Zero
    );

  -- Logical Operation Components
  and_01: andg2
    port map (
      i_A => w_OVERFLOW,
      i_B => w_SignedOrUnsigned, -- (1)Signed, (0)Unsigned
      o_F => o_ALU_Overflow
    );
  and_32: andg_N
    port map (
      i_A   => i_ALU_A,
      i_B   => i_ALU_B,
      o_Out => w_AND
    );

  or_32: org_N
    port map (
      i_A   => i_ALU_A,
      i_B   => i_ALU_B,
      o_Out => w_OR
    );

  xor_32: xorg_N
    port map (
      i_A   => i_ALU_A,
      i_B   => i_ALU_B,
      o_Out => w_XOR
    );

  nor_32: norg_N
    port map (
      i_A   => i_ALU_A,
      i_B   => i_ALU_B,
      o_Out => w_NOR
    );

  ---------------------------------------------------------------------------
  -- Level 1: Intermediate Computation and Shift Operations
  ---------------------------------------------------------------------------
  -- Shift Component
  shift: Shifter
    port map (
      i_in        => i_ALU_B,
      i_shift_C   => i_ALU_Ctl(3),        -- (0) Logical, (1) Arithmatic
      i_Direction => i_ALU_Ctl(0),        -- (0) left, (1) Right
      i_Shamt     => i_ALU_A(4 downto 0), -- amount to shift/ shamt we get the shift amount from A every time, so we know how much to shift.           
      o_Out       => w_Shift --we can shift using imm value, shift amount 
    );

  ---------------------------------------------------------------------------
  -- Level 2: Multiplexing Output Based on Operation Selector
  ---------------------------------------------------------------------------
  -- Multiplexer Component for Operation Selection
  mux: mux8t1_N
    port map (
      i_w0 => w_AddSub, -- add/sub
      i_w1 => w_Shift,  -- Shift Right 
      i_w2 => w_Shift,  -- Shift left
      i_w3 => w_AND,
      i_w4 => w_OR,
      i_w5 => w_XOR,
      i_w6 => w_NOR,
      i_w7 => w_Lui,    -- for Lui
      i_s0 => i_ALU_Ctl(0),
      i_s1 => i_ALU_Ctl(1),
      i_s2 => i_ALU_Ctl(2),
      o_Y  => o_ALU_I_Result
    );

end architecture;
