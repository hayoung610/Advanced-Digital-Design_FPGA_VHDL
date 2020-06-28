library ieee;
use ieee.std_logic_1164.all;

entity prob105 is
    port(
        clk, reset: in std_logic;
        start: in std_logic; -- input
        data_out: out std_logic --output
    );
end prob105;

architecture arch of prob105 is
    type mc_state_type is 
        (idle, dataout1, dataout2, dataout3, dataout4,
        dataout5, dataout6, dataout7, dataout8); --all state
    signal state_reg, state_next: mc_state_type;
    
begin
    -- state register
    process(clk, reset)
    begin
        if (reset = '1') then
            state_reg <= idle;
        else if (clk'event and clk = '1') then
            state_reg <= state_next;
        end if;
    end process;
    
    -- next state logic
    process(state_reg, start)
    begin
        case state_reg is
            when idle =>       --state idle
                if start = '1' then
                    state_next <= dataout1;
                else        -- start = '0'
                    state_next <= idle;
                end if;
            
            when dataout1 =>       -- state dataout1 
                state_next <= dataout2;
            when dataout2 =>       -- state dataout2 
                state_next <= dataout3;
            when dataout3 =>       -- state dataout3 
                state_next <= dataout4;
            when dataout4 =>       -- state dataout4 
                state_next <= dataout5;
            when dataout5 =>       -- state dataout5 
                state_next <= dataout6;
            when dataout6 =>       -- state dataout6 
                state_next <= dataout7;
            when dataout7 =>       -- state dataout7 
                state_next <= dataout8;
            
            when dataout8 =>       -- state dataout8 
                if start = '1' then
                    state_next <= dataout1;
                else                -- start = '0'
                    state_next <= idle;
               end if;
            when others =>
                    state_next <= idle;
        end case;
    end process;
    
    --Moore output logic
    process(state_reg)
    begin
        data_out <= '0'; --default value
        case state_reg is
            when idle =>    -- no output
            when dataout1 => --when state dataout1
                data_out <= '1'; --give output data_out as 1
            when dataout2 => 
                data_out <= '0';
            when dataout3 => 
                data_out <= '1';
            when dataout4 => 
                data_out <= '0';
            when dataout5 => 
                data_out <= '1';
            when dataout6 => 
                data_out <= '0';
            when dataout7 => 
                data_out <= '1';
            when dataout8 => 
                data_out <= '0';
        end case;
    end process;
end arch;
