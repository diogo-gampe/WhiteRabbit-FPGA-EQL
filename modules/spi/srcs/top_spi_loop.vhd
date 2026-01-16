library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_spi_loop is
  port(
    clock_p   : in  std_logic;
    clock_n   : in  std_logic;
    reset_n : in  std_logic;

    -- pinos externos
    sclk  : out std_logic;
    mosi  : out std_logic;
    miso  : in  std_logic;
    ss_n  : out std_logic
  );
end;

architecture rtl of top_spi_loop is
  signal enable   : std_logic := '0';
  signal cpol     : std_logic := '0';
  signal cpha     : std_logic := '0';
  signal cont     : std_logic := '0';
  signal busy     : std_logic;
  signal rx_data  : std_logic_vector(7 downto 0);
  signal ss_vec  : std_logic_vector(0 downto 0);
  signal clock : std_logic;

  -- bem lento pra começar: se clock=50MHz e clk_div=50 => SCLK ~ 500kHz
  constant CLK_DIV : integer := 50;
  constant TX_BYTE : std_logic_vector(7 downto 0) := x"A5";
begin
    
    IBUFDS_inst : IBUFDS
    port map (
        O => clock, -- Saída para sua lógica
        I => clock_p, -- Pino positivo do sinal diferencial
        IB => clock_n -- Pino negativo do sinal diferencial
    );

  -- instancia seu master (com slaves=1, d_width=8)
  u_spi: entity work.spi_master
    generic map(
      slaves => 1,
      d_width => 8
    )
    port map(
      clock   => clock,
      reset_n => reset_n,
      enable  => enable,
      cpol    => cpol,
      cpha    => cpha,
      cont    => cont,
      clk_div => CLK_DIV,
      addr    => 0,
      tx_data => TX_BYTE,
      miso    => miso,
      sclk    => sclk,
      ss_n    => ss_vec,
      mosi    => mosi,
      busy    => busy,
      rx_data => rx_data
    );
    
  ss_n <= ss_vec(0);
  
  -- gera pulso de enable sempre que o master estiver pronto
  process(clock, reset_n)
  begin
    if reset_n = '0' then
      enable <= '0';
    elsif rising_edge(clock) then
      if busy = '0' then
        enable <= '1';      -- 1 ciclo
      else
        enable <= '0';
      end if;
    end if;
  end process;
end;