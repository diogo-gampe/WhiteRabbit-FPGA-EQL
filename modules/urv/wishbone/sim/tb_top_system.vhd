library ieee;
use ieee.std_logic_1164.all;

entity tb_top_system is
end tb_top_system;

architecture sim of tb_top_system is
    signal clk_p : std_logic := '0';
    signal clk_n : std_logic := '1'; 
    signal leds  : std_logic_vector(1 downto 0);

begin

    clk_p <= not clk_p after 2.5 ns;
    clk_n <= not clk_p; 
    
    UUT: entity work.top_system
        port map (
            sys_clk_p => clk_p,
            sys_clk_n => clk_n, 
            led_o     => leds   
        );

end sim;