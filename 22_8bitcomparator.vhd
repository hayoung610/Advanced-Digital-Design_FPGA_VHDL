library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity prob44 is
    port(
        a, b: in std_logic_vector(7 downto 0); --input a, b
        agtb: out std_logic --comparator coutput agtb
    );
end prob44;

architecture arch of prob44 is
   
begin
 --agtb: Start to compare each bit of a and b from the 
 -- most significant bit (a(7), b(7))
 -- If a(i) is bigger than  b(i), agtb is 1 (agtb asserted) / i = 7 to 0
 -- If a(i) is smaller than b(i), agtb is 0
 -- If a(i) is equal to b(i) than it checks the next right bit (i-1)
 -- Repeat this step until All 8 bits are checked.
 -- If a is same as b, it agtb is zero
    agtb < = '1' when a(7) > b(7) else  
             '0' when a(7) < b(7) else
             '1' when a(6) > b(6) else
             '0' when a(6) < b(6) else
             '1' when a(5) > b(5) else
             '0' when a(5) < b(5) else
             '1' when a(4) > b(4) else
             '0' when a(4) < b(4) else
             '1' when a(3) > b(3) else
             '0' when a(3) < b(3) else
             '1' when a(2) > b(2) else
             '0' when a(2) < b(2) else
             '1' when a(1) > b(1) else
             '0' when a(1) < b(1) else
             '1' when a(0) > b(0) else
             '0' when a(0) < b(0) else
             '0';
end arch
