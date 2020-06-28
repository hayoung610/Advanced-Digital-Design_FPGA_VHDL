library ieee;
use ieee.std_logic_1164.all;

entity prob106 is
    port(
        clk, reset: in std_logic;
        data_in: in std_logic; -- input
        match: out std_logic --output
    );
end prob106;

architecture arch of prob106 is
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
    process(state_reg, data_in)
    begin
        case state_reg is
            when idle =>       --state idle
                if data_in = '1' then
                    state_next <= dataout1;
                else        -- data_in = '0'
                    state_next <= idle;
                end if;
            
            when dataout1 =>       
                if data_in = '1' then
                    state_next <= dataout1;
                else        --data_in = '0'
                    state_next <= dataout2;
                    
            when dataout2 =>
                if data_in = '1' then
                    state_next <= dataout3;
                else        -- data_in = '0'
                    state_next <= idle;
                end if;
                
            when dataout3 =>       
                if data_in = '1' then
                    state_next <= dataout1;
                else        --data_in = '0'
                    state_next <= dataout4;
                    
            when dataout4 =>
                if data_in = '1' then
                    state_next <= dataout5;
                else        -- data_in = '0'
                    state_next <= idle;
                end if;
                
            when dataout5 =>       
                if data_in = '1' then
                    state_next <= dataout1;
                else        --data_in = '0'
                    state_next <= dataout6;
                    
            when dataout6 =>
                if data_in = '1' then
                    state_next <= dataout7;
                else        -- data_in = '0'
                    state_next <= idle;
                end if;
                
            when dataout7 =>       
                if data_in = '1' then
                    state_next <= dataout1;
                else        --data_in = '0'
                    state_next <= dataout8;
                    
            when dataout8 =>
                if data_in = '1' then
                    state_next <= dataout1;
                else        -- data_in = '0'
                    state_next <= idle;
                end if;
        end case;
    end process;
    
    --Moore output logic
    process(state_reg)
    begin
        match <= '0'; --default value
        case state_reg is
            when idle =>    -- no output
            when dataout1 => 
            when dataout2 => 
            when dataout3 => 
            when dataout4 => 
            when dataout5 => 
            when dataout6 => 
            when dataout7 => 
            when dataout8 => 
                match <= '1';
        end case;
    end process;
end arch;
