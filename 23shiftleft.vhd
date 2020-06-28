library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity prob46 is
    port(
    a : in std_logic_vector(7 downto 0); -- input 8 bit a
    ctrl: in std_logic_vector(2 downto 0); --ctrl  3 bit signal
    y: out std_logic_vector(7 downto 0) -- output 8 bit
    );
end prob46;

architecture arch of prob46 is
    begin
        with ctrl select
        y <= a when "000",
             a(6 downto 0) & "0" when "001",
             a(5 downto 0) & "00" when "010",
             a(4 downto 0) & "000" when "011",
             a(3 downto 0) & "0000" when "100",
             a(2 downto 0) & "00000" when "101",
             a(1 downto 0) & "000000" when "110",
             a(0) & "0000000" when others;
end arch;
