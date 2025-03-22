library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_alarme is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        comparador   : in  std_logic; 
        btn_liga_desliga : in  std_logic; 
        led_L1       : out std_logic; 
        led_L2       : out std_logic;
        btn_alarme    : in  std_logic 
    );
end entity;

architecture behavior of controle_alarme is
    type estagios is (ESPERA, ARMADO, ATIVADO, DESATIVADO);
    signal estagio_atual, prox_estagio : estagios;
    signal led_L2_pisca                : std_logic := '0'; 
    signal clk_div : std_logic := '0'; 
    signal count : integer := 0;      
    constant CLK_DIVIDE : integer := 50000000; -- 2 Hz ( 100 MHz clock)
begin

    -- DIVISOR DE FREQUENCIA
    process(clk, rst)
    begin
        if rst = '1' then
            count <= 0;
            clk_div <= '0';
        elsif rising_edge(clk) then
            if count = CLK_DIVIDE - 1 then
                count <= 0;
                clk_div <= not clk_div;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            estagio_atual <= ESPERA;
        elsif rising_edge(clk) then
            estagio_atual <= prox_estagio;
        end if;
    end process;

    process(estagio_atual, comparador, btn_liga_desliga, btn_alarme, clk_div)
    begin
        -- Inicialmente, manter no estado atual
        prox_estagio <= estagio_atual;
        led_L1 <= '0';
        led_L2 <= '0';
        
        -- Se a chave alarme estiver ligada, permanece em ESPERA
        if btn_alarme = '1' then
            prox_estagio <= ESPERA;
        else
            case estagio_atual is
                when ESPERA =>
                    if btn_liga_desliga = '1' then
                        prox_estagio <= ARMADO;
                    end if;
                    
                when ARMADO =>
                    led_L1 <= '1';
                    if comparador = '1' then
                        prox_estagio <= ATIVADO;
                    elsif btn_liga_desliga = '1' then
                        prox_estagio <= ESPERA;
                    end if;
                    
                when ATIVADO =>
                    led_L1 <= '1';
                    led_L2 <= clk_div; -- 2Hz
                    if btn_liga_desliga = '1' then
                        prox_estagio <= DESATIVADO;
                    end if;
                    
                when DESATIVADO =>
                    led_L1 <= '0';
                    led_L2 <= '0';
                    if btn_liga_desliga = '1' then
                        prox_estagio <= ESPERA;
                    end if;
                    
                when others =>
                    prox_estagio <= ESPERA;
            end case;
        end if;
    end process;

end architecture;
