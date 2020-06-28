library ieee;
use ieee.std_logic_1164.all;

entity prob102 is
    port(
        clk, reset: in std_logic;
        mem, rw, burst: in std_logic; -- input
        oe, we, we_me: out std_logic --output
    );
end prob102;

architecture arch of prob102 is
    type mc_state_type is 
        (idle, read1, read2, read3, read4, write); --define all state
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
    process(state_reg, mem, rw, burst)
    begin
        case state_reg is
            when idle =>       --state idle
                if mem = '1' then
                    if rw = '1' then
                        state_next <= read1;
                    else        -- rw = '0'
                        state_next <= write;
                    end if;
                else            -- mem = '0'
                    state_next <= idle;
                end if;
            
            when read1 =>       -- state read1 
                if (burst = '1') then
                    state_next <= read2;
                else            -- burst ='0'
                    if mem = '1' then
                        if rw = '1' then
                            state_next <= read1;
                        else    -- rw = '0'
                            state_next <= write;
                        end if;
                    else        -- mem = '0'
                        state_next <= idle;
                    end if;
                end if;
            
            when read2 =>
                state_next <= read3;
            when read3 =>
                state_next <= read4;
            
            when read4 =>      -- state read4
                if mem = '1' then
                    if rw = '1' then
                        state_next <= read1;
                    else        -- rw = '0'
                        state_next <= write;
                    end if;
                else            -- mem = '0'
                    state_next <= idle;
                end if;
                
            when write =>        -- state write
                if mem = '1' then
                    if rw = '1' then
                        state_next <= read1;
                    else        -- rw = '0'
                        state_next <= write;
                    end if;
                else            -- mem = '0'
                    state_next <= idle;
                end if;
                
        end case;
    end process;
    
    --Moore output logic
    process(state_reg)
    begin
        we <= '0'; --default value
        oe <= '0'; --default value
        case state_reg is
            when idle =>    -- no output
            when read1 =>
                oe <= '1';
            when read2 =>
                oe <= '1';
            when read3 =>
                oe <= '1';
            when read4 =>
                oe <= '1';
            when write =>
                we <= '1';
        end case;
    end process;
    
    -- Mealy output logic
    process(state_reg, mem, rw)
    begin
        we_me <= '0'; --default value
        case state_reg is 
            when idle =>
                if (mem = '1') and (rw = '0') then
                    we_me <= '1';
                end if;
            when read1 =>
                if (burst = '0') and (mem = '1') and (rw = '0') then
                    we_me <= '1';
                end if;
                
            when read2 =>
            when read3 =>
            when read4 =>
                if (mem = '1') and (rw = '0') then
                    we_me <= '1';
                end if;
            when write =>
                if (mem = '1') and (rw = '0') then
                    we_me <= '1';
                end if;
        end case;
    end process;
end arch;
