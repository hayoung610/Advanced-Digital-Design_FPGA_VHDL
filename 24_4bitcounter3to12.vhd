library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prob87 is
    port(
        clk, reset: in std_logic; --input 
        q: out std_logic_vector (3 downto 0) -- output q
    );    
end prob87;

architecture arch of prob87 is
    signal r_reg : unsigned (3 downto 0);
    signal r_next : unsigned (3 downto 0);
begin
    -- register
    process (clk, reset)
    begin
        if (reset='1') then
            r_reg <= "0011"; --reset r_reg to "0011"
        elsif (clk'event and clk='1') then
            r_reg <= r_next; 
        end if ;
    end process;
    
    --next state logic  (incrementer)
    -- when there is noise (r_reg = 0000,0001, 0010, 1101, 1110, 1111)
    -- or when r_reg reaches 1100, 
    -- r_next is given as 0011
    r_next <=
        "0011" when r_reg = "1100" or r_reg = "1101" or r_reg = "1110" or
                    r_reg = "1111" or r_reg = "0000" or r_reg = "0001" or
                    r_reg = "0010" else
        r_reg + 1; --otherwise, increment r_reg
     -- output logic
    q <= std_logic_vector(r_reg);
end arch;  
