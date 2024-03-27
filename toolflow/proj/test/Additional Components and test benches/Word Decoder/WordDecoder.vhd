library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WordDecoder is
    Port ( i_offset : in STD_LOGIC_VECTOR(1 downto 0);
           o_output : out STD_LOGIC_VECTOR(4 downto 0));
end WordDecoder;

architecture Behavioral of WordDecoder is
begin
    process(i_offset)
    begin
        case i_offset is
            when "0" =>
                o_output <= "10000";
            when "1" =>
                o_output <= "00000";
            when others =>
                o_output <= "00000"; -- Undefined/invalid input handling.
        end case;
    end process;
end Behavioral;
