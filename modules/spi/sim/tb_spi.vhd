library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_spi_master is
end entity;

architecture sim of tb_spi_master is
  constant SLAVES  : integer := 1;
  constant D_WIDTH : integer := 16;

  constant T_SYS : time := 10 ns; -- 100 MHz

  signal clock   : std_logic := '0';
  signal reset_n : std_logic := '0';

  signal enable  : std_logic := '0';
  signal cpol    : std_logic := '0';
  signal cpha    : std_logic := '0';
  signal cont    : std_logic := '0';
  signal clk_div : integer   := 0;   -- mais alto = SCLK mais lento
  signal addr    : integer   := 0;

  signal tx_data : std_logic_vector(D_WIDTH-1 downto 0) := x"5555";
  signal rx_data : std_logic_vector(D_WIDTH-1 downto 0);

  signal miso : std_logic := '0';  -- SEM SLAVE: force aqui um padrão
  signal mosi : std_logic;
  signal sclk : std_logic;
  signal ss_n : std_logic_vector(SLAVES-1 downto 0);
  signal busy : std_logic;

begin
  -- clock do sistema
  clock <= not clock after T_SYS/2;

  -- DUT
  dut: entity work.spi_master
    generic map (
      slaves  => SLAVES,
      d_width => D_WIDTH
    )
    port map (
      clock   => clock,
      reset_n => reset_n,
      enable  => enable,
      cpol    => cpol,
      cpha    => cpha,
      cont    => cont,
      clk_div => clk_div,
      addr    => addr,
      tx_data => tx_data,
      miso    => miso,
      sclk    => sclk,
      ss_n    => ss_n,
      mosi    => mosi,
      busy    => busy,
      rx_data => rx_data
    );

  -- Estímulos
  p_stim: process
  begin
    -- reset
    reset_n <= '0';
    enable  <= '0';
    cont    <= '0';
    cpol    <= '0';   -- MODE 1 (cpol=0 cpha=1) pra começar
    cpha    <= '1';
    clk_div <= 0;     -- deixa bem lento pra ver no waveform
    addr    <= 0;
    tx_data <= x"5555"; -- por exemplo: comando JEDEC ID (só pra waveform)
    miso    <= '0';   -- sem slave, rx vai virar 0 (ou algo se você mexer aqui)
    

    wait for 50 ns;
    reset_n <= '1';
    -- dispara 1 transação (pulso de enable)
    enable <= '1';
    wait for T_SYS;
    enable <= '0';
    
    wait for 500 us;
  end process;

end architecture;