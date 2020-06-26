library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity prob1 is
    port(
        clk, reset: in std_logic;
        start: in std_logic;
        yin, din: in std_logic_vector(7 downto 0); -- input y,d
        ready, error: out std_logic;
        qout, rout: out --output std_logic_vector(7 downto 0)
    );
end prob1;

architecture arch of prob1 is
    type state_type is (idle, Error, zero, load, op, stop); -- state
    signal state_reg, state_next: state type;
    signal d_is_0, y_is_0, d_leq_y, d_big_y: std_logic;
    signal y_reg, y_next: unsigned(7 downto 0);
    signal d_reg, d_next: unsigned(7 downto 0);
    signal q_reg, q_next: unsigned(7 downto 0);
    signal r_reg, r_next: unsigned(7 downto 0);
    signal add_out, sub_out: unsigned(7 downto 0);
    
begin
    -- control path: state register
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg <= idle;
        elsif (clk'event and clk='1') then
            state_reg <= state_next;
        end if;
    end process;
    --control path: next-state/output logic
    process(state_reg,start,d_is_0, y_is_0, d_leq_y, d_big_y)
    begin
        case state_reg is
            when idle =>
                if start = '1' then
                    if (d_is_0 = '1' ) then
                        state_next <= Error;
                    elsif (y_is_0 = '1') then
                        state_next <= zero;
                    else
                        state_next <= load;
                    end if;
                else
                    state_next <= idle;
                end if;
            when Error =>
                state_next <= idle;
            when zero =>
                state_next <= idle;
            when load=>
                if (d_leq_y = '1') then
                    state_next <= op;
                else
                    state_next <= stop;
                end if;
            when op =>
                if (d_big_y = '1') then
                    state_next <= stop;
                else
                    state_next <= op;
                end if;
        end case;
    end process;
    -- control path: output logic
    ready <= '1' when state_reg = idle else '0';
    error <= '1' when state_reg = Error else '0';
    -- data path: data register
    process(clk, reset)
    begin
        if reset = '1' then
            y_reg <= (others => '0');
            d_reg <= (others => '0');
            q_reg <= (others => '0');
            r_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            y_reg <= y_next;
            d_reg <= d_next;
            q_reg <= q_next;
            r_reg <= r_next;
        end if;
    end process;
    -- data path: routing multiplexer
    process(state_reg, y_reg, d_reg, q_reg, 
            r_reg, yin, din, add_out, sub_out)
    begin
        case state_reg is
            when idle =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= q_reg;
                r_next <= r_reg;
            when Error =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= q_reg;
                r_next <= r_reg;
            when zero =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= (others => '0');
                r_next <= (others => '0');
            when load =>
                y_next <= unsigned(yin);
                d_next <= unsigned(din);
                q_next <= (others => '0');
                r_next <= (others => '0');
            when op =>
                y_next <= sub_out;
                d_next <= d_reg;
                q_next <= add_out;
                r_next <= r_reg;
            when stop =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= q_reg;
                r_next <= y_reg;
        end case;
    end process;
    -- data path: functional units
    add_out <= q_reg + 1;
    sub_out <= y_reg - d_reg;
    -- data path : status
    d_is_0 <= '1' when din = "00000000" else '0';
    y_is_0 <= '1' when yin = "00000000" else '0';
    d_leq_y <= '0' when d_reg > yin else '1';
    d_big_y <= '1' when d_reg > sub_out else '0';
    -- data path: output
    qout < = std_logic_vector(q_reg);
    rout < = std_logic_vector(r_reg);
end arch;
