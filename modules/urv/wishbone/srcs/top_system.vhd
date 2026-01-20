library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.wishbone_pkg.all; 

entity top_system is
    port (
        sys_clk_p   : in  std_logic; 
        sys_clk_n   : in  std_logic; 
        led_o       : out std_logic_vector(1 downto 0) 
    );
end top_system;

architecture rtl of top_system is

    component clk_wiz_0
        port (
            clk_in1  : in  std_logic;
            clk_out1 : out std_logic;
            locked   : out std_logic
        );
    end component;
    
    signal clk_200m_buffered : std_logic;
    signal clk_62_5MHz : std_logic; 
    signal locked    : std_logic;
    
    signal cpu_dwb_out : t_wishbone_master_out;
    signal cpu_dwb_in  : t_wishbone_master_in;
    
    signal led1_reg : std_logic := '0';
    signal test_reg   : std_logic_vector(31 downto 0) := x"00000000";

begin

    -- Instância do Buffer Diferencial
    IBUFDS_inst : IBUFDS
        port map (
            O  => clk_200m_buffered, 
            I  => sys_clk_p,        
            IB => sys_clk_n          
        );

 
    u_clock_gen : clk_wiz_0
        port map (
            clk_in1  => clk_200m_buffered, 
            clk_out1 => clk_62_5MHz, 
            locked   => locked 
        );

    -- Instância do RISC-V 
    u_processor : entity work.xurv_core
        generic map (
            g_internal_ram_init_file => "C:/Users/ludmi/lclm/helloworldURV/wishboneTEST/firmware.mem", 
            g_internal_ram_size      => 65536
        )
        port map (
            clk_sys_i    => clk_62_5MHz,
            rst_n_i      => locked,        
            cpu_rst_i    => '0',
            irq_i        => x"00",
            dwb_o        => cpu_dwb_out,               -- saída do master
            dwb_i        => cpu_dwb_in,                -- entrada do master 
            host_slave_i => cc_dummy_slave_in,
            host_slave_o => open
        );

   process(clk_62_5MHz)
    begin
        if rising_edge(clk_62_5MHz) then
            if locked = '0' then
                -- estado de Reset
                cpu_dwb_in.ack   <= '0';
                cpu_dwb_in.err   <= '0';
                cpu_dwb_in.rty   <= '0';
                cpu_dwb_in.stall <= '0';
                cpu_dwb_in.dat   <= (others => '0');
                test_reg         <= (others => '0');
                led1_reg         <= '0';
            else
                -- lógica padrão
                cpu_dwb_in.ack   <= '0';
                cpu_dwb_in.err   <= '0';
                cpu_dwb_in.rty   <= '0';
                cpu_dwb_in.stall <= '0';

                -- monitoramento do Ciclo Wishbone
                -- CYC indica o uso do barramento e STB indica transferência válida
                if cpu_dwb_out.cyc = '1' and cpu_dwb_out.stb = '1' then
                    
                    -- decodificador de endereço 
                    if cpu_dwb_out.adr(31 downto 28) = x"8" then
                        
                        -- 0x80000000 (Controle do LED)
                        if cpu_dwb_out.adr(11 downto 0) = x"000" then
                            if cpu_dwb_out.we = '1' then
                                led1_reg <= cpu_dwb_out.dat(0);
                            end if;
                            cpu_dwb_in.dat <= (0 => led1_reg, others => '0');
                            cpu_dwb_in.ack <= '1'; 
                            
                        -- 0x80000100 (Registrador de teste de dados)
                        elsif cpu_dwb_out.adr(11 downto 0) = x"100" then
                            if cpu_dwb_out.we = '1' then
                                test_reg <= cpu_dwb_out.dat;
                            end if;
                            cpu_dwb_in.dat <= test_reg; -- Permite leitura do valor escrito
                            cpu_dwb_in.ack <= '1'; -- Resposta de confirmação
                        
                        else
                            -- Endereço dentro do range 0x8 mas não mapeado
                            cpu_dwb_in.err <= '1'; -- indica erro de barramento
                            cpu_dwb_in.ack <= '1'; -- devolve a informação de que a CPU pode contuinuar
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Atribuição física dos LEDs
    led_o(0) <= locked;      -- LED 0: Status do Clock (ON se estável)
    led_o(1) <= led1_reg;    -- LED 1: Controlado via Software (Endereço 0x80000000)

end rtl;