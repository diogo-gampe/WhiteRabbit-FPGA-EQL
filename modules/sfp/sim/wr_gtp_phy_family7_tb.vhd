library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wr_gtp_phy_family7_tb is
end wr_gtp_phy_family7_tb;

architecture behavior of wr_gtp_phy_family7_tb is

    -- Sinais para conectar ao UUT
    signal clk_gtp     : std_logic := '0';
    signal rst         : std_logic := '1';
    signal tx_data     : std_logic_vector(15 downto 0) := x"0000";
    signal tx_k        : std_logic_vector(1 downto 0) := "00";
    signal rx_data     : std_logic_vector(15 downto 0);
    signal tx_out_clk  : std_logic;
    signal tx_locked   : std_logic;
    signal rdy         : std_logic;
    signal state       : std_logic_vector(1 downto 0);

    -- Período de 125 MHz = 8ns
    constant CLK_PERIOD : time := 8 ns;

begin

    -- Instanciação da Unidade Sob Teste (UUT)
    uut: entity work.wr_gtp_phy_family7
    generic map (
        g_simulation => 1  -- Ativa modo rápido para simulação
    )
    port map (
        clk_gtp_i      => clk_gtp,
        rst_i          => rst,
        tx_data_i      => tx_data,
        tx_k_i         => tx_k,
        tx_out_clk_o   => tx_out_clk,
        tx_locked_o    => tx_locked,
        rx_data_o      => rx_data,
        rdy_o          => rdy,
        -- Conectar os pads em loopback virtual 
        pad_txn_o      => open,
        pad_txp_o      => open,
        pad_rxn_i      => '0',
        pad_rxp_i      => '0'
    );

    -- Gerador de Clock (125 MHz)
    clk_process : process
    begin
        clk_gtp <= '0';
        wait for CLK_PERIOD/2;
        clk_gtp <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Processo de Estímulo
    stim_proc: process
    begin		
        -- 1. Inicia em Reset
        rst <= '1';
        wait for 90 ns;
        
        -- 2. Libera o Reset
        rst <= '0';
        
        -- 3. Aguarda o PHY sinalizar que está pronto (Ready)
        -- No modo g_simulation=1, isso deve levar alguns microsegundos
        wait until rdy = '1';
        report "PHY Ready! Iniciando transmissão...";

        -- 4. Envia alguns dados (Simulando protocolo 8b10b)
        wait until rising_edge(tx_out_clk);
        tx_data <= x"BCB5"; -- Exemplo de caractere K28.5 (Comma)
        tx_k    <= "11";
        
        wait until rising_edge(tx_out_clk);
        tx_data <= x"1234"; -- Dados normais
        tx_k    <= "00";

        wait for 1 ms;
        assert false report "Fim da simulação" severity failure;
    end process;

end behavior;