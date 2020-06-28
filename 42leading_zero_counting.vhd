library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity prob2 is
    port(
    clk, reset: in std_logic;
    start: in std_logic;
    signal_in: in std_logic_vector(7 downto 0);
    ready: out std_logic;
    nout: out std_logic_vector(7 downto 0);
    );
end prob2;

architecture arch of prob2 is
    type state_type is (idle, load, count, stop);
    signal state_reg, state_next: state_type;
    signal a7_is_1, atmp_is_1, tmp_is_0: std_logic;
    signal a_reg, a_next: unsigned (7 downto 0);
    signal n_reg, n_next: unsigned (7 downto 0);
    signal tmp_reg, tmp_next: unsigned (7 downto 0);
    signal add_out, sub_out: unsigned(7 downto 0);
begin
    --control path: state register
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg <= idle;
        elsif (clk'event and clk = '1') then
            state_reg <= state_next;
        end if;
    end process;
    --control path: next-state/ output logic
    process(state_reg, start, a7_is_1, atmp_is_1, tmp_is_0)
    begin
        case state_reg is
            when idle =>
                if start = '1' then
                    state_next <= load;
                else
                    state_next<= idle;
                end if;
            when load =>
                if a7_is_1 = '1' then
                    state_next <= stop;
                else
                    state_next <= count;
                end if;
            when count =>
                if tmp_is_0 = '1' then
                    state_next <= stop;
                elsif atmp_is_1 = '1' then
                    state_next <= stop;
                else
                    state_next <= count;
            when stop =>
                state_next <= idle;
        end case;
    end process;
    -- control path: output logic
    ready <= '1' when state_reg = idle else '0';
    -- data path: data register
    process (clk, reset)
    begin
        if reset = '1' then
            a_reg <= (others => '0');
            n_reg <= (others => '0');
            tmp_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            a_reg <= a_next;
            n_reg <= n_next;
            tmp_reg <= tmp_next;
        end if;
    end process;
    -- data path: routing multiplexer
    process(state_reg, a_reg, n_reg, tmp_reg, signal_in, add_out, sub_out)
    begin
        case state_reg is
            when idle =>
                a_next <= a_reg;
                n_next <= n_reg;
                tmp_next <= tmp_reg;
            when load =>
                a_next <= unsigned(signal_in);
                n_next <= (others => '0');
                tmp_next <= "00001000";
            when count =>
                a_next <= a_reg;
                n_next <= add_out;
                tmp_next <= sub_out;
            when stop =>
                a_next <= a_reg;
                n_next <= n_reg;
                tmp_next <= tmp_reg;
        end case;
    end process;
    -- data path: functional units
    add_out <=  n_reg + 1;
    sub_out <= tmp_reg -1;
    -- data path: status
    a7_is_1 <= '1' when signal_in(7) = '1' else '0';
    atmp_is_1 <= '1' when signal_in(tmp-1) = '1' else '0';
    tmp_is_0 <= '1' when sub_out = "00000000" else '0';
    -- data path: output
    nout <= std_logic_vector(n_reg);
end arch;
