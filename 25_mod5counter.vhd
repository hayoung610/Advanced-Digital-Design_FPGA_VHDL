library ieee;
use ieee.std_logic_1164.all ; 
entity prob88 is
    port ( 
        clk, reset: in std_logic; --clock, reset signal
        q: out std_logic_vector (2 downto 0) -- 3 bit output q
    );
end prob88;

architecture arch of prob88 is
    signal r_reg: std_logic_vector (2 downto 0);
    signal r_next : std_logic_vector (2 downto 0);
begin
    -- register 
    process (clk, reset)
    begin
        if (reset='1') then --reset the r_reg to 000
            r_reg <= (others=>'O'); 
        elsif (clk'event and clk='1') then 
            r_reg <= r_next; 
        end if ;
end process;
-- next-state logic
-- Follow mod 5 counter
-- When r_reg reaches 100, the r_next is 000
-- or when r_reg has noise(101,110,111) r_next is 000
r_next <= "001" when r_reg="OOO" else --increment
          "010" when r_reg="001" else
          "011" when r_reg="010" else 
          "100" when r_reg="011" else
          "000"; --otherwise, r_next = 000 to impliment mod 5 counter
    -- output logic
    q <= r_reg;
end arch ;
          
