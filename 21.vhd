library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity prob43 is
    port(
        ctrl: in std_logic_vector(1 downto 0); --ctrl signal input
        x: in std_logic_vector(1 downto 0); --input x
        y: out std_logic_vector(1 downto 0) --output y
    );
end prob43;

architecture arch of prob43 is
begin
    with ctrl select
      y <= x when "00", --when ctrl = "00", y = x = x1 x0
           x(0) & x(1) when "01", --when ctrl = "01", y = x0 x1
           x(0) & x(0) when "10", --when ctrl = "10", y = x0 x0
           x(1) & x(1) when others; --when ctrl = "11", y = x1 x1
end arch;
