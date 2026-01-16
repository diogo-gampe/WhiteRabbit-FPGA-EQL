library ieee;
use ieee.std_logic_1164.all;

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
    signal led1_reg : std_logic := '0';

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
            g_internal_ram_init_file => "C:\Users\lenovo\Documentos\Dobslit\Vivado Projects\sw_urv\helloworldURV\firmware.mem", 
            g_internal_ram_size      => 65536
        )
        port map (
            clk_sys_i    => clk_62_5MHz,
            rst_n_i      => locked,        
            cpu_rst_i    => '0',
            irq_i        => x"00",
            dwb_o        => cpu_dwb_out,   
            dwb_i        => cc_dummy_master_in,
            host_slave_i => cc_dummy_slave_in,
            host_slave_o => open
        );

    process(clk_62_5MHz)
    begin
        if rising_edge(clk_62_5MHz) then
          
            if cpu_dwb_out.stb = '1' and cpu_dwb_out.adr(31) = '1' then
                led1_reg <= not led1_reg; -- Inverte o LED (Toggle)
            end if;
        end if;
    end process;
    
    led_o(0) <= locked;              -- LED 0: ON quando o clocka
    led_o(1) <= led1_reg;            -- LED 1: muda de estado quando stb pulsa

end rtl;