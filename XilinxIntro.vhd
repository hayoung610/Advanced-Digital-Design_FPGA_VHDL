--XilinxIntro.vhd
--Basic setup
library ieee; --setup library IEEE
use ieee.std_logic_1164.all;    --setup use STD_LOGIC_1164 package

entity XilinxIntro is --declaration of entity named XilinxIntro
  
  port (  --port declaration
    switches : in  std_logic_vector(7 downto 0);
    buttons : in  std_logic_vector(3 downto 0);
    leds : out std_logic_vector(7 downto 0));
   ); --defining input and output port named switches, buttons, 
      -- leds ports with type std_logic_vector  
    -- 7 downto 0 implies a vector of 8 bits
    -- 3 downto 0 implies a vector of 4 bits
end XilinxIntro;

architecture simple of XilinxIntro is --define architecture

begin  --begin architecture simple statement

  leds <= "00000000" when buttons(0)='1' else
          -- Turn off all leds when button 0 is pressed
          "11111111" when buttons(1)='1' else
        -- Turn on all leds when button 1 is pressed
          switches;

end simple;

architecture simple2 of XilinxIntro is

begin  -- simple2 --begin architecture simple2 statement

  leds <= "11111111" when buttons(1)='1' else
            -- Turn on all leds when button 1 is pressed
          "00000000" when buttons(0)='1' else
            -- Turn off all leds when button 0 is pressed
          switches;
end simple2;
