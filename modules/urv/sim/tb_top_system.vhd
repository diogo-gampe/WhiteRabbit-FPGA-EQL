library ieee;
use ieee.std_logic_1164.all;

entity tb_top_system is
end tb_top_system;

architecture sim of tb_top_system is
    signal clk : std_logic := '0';
    signal leds : std_logic_vector(1 downto 0);
begin
    -- Instancia o top level
    UUT: entity work.top_system
        port map (
            sys_clk_i => clk,
            led_o     => leds
        );

    clk <= not clk after 2.5 ns;

end sim;