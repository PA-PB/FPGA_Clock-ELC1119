library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_selecao is
    port (
        dezena_hora_alarme     : in unsigned(3 downto 0);         
        unidade_hora_alarme    : in unsigned(3 downto 0);         
        dezena_minuto_alarme   : in unsigned(3 downto 0);        
        unidade_minuto_alarme  : in unsigned(3 downto 0);        

        dezena_hora_contador   : in unsigned(3 downto 0);         
        unidade_hora_contador  : in unsigned(3 downto 0);         
        dezena_minuto_contador : in unsigned(3 downto 0);        
        unidade_minuto_contador: in unsigned(3 downto 0);   
        
        saida                : out std_logic_vector(3 downto 0);
        habilita             : in std_logic;
        rst                  : in std_logic;
        btn_alarme           : in std_logic;
        clk                  : in std_logic;
        btn_incrementa_hora  : in std_logic;
        btn_incrementa_minuto: in std_logic;
        selecao              : in std_logic_vector(1 downto 0)
    );
end entity;

architecture comportamento of mux_selecao is
    signal unidades_hora_alarme_int      : unsigned(3 downto 0);
    signal dezenas_hora_alarme_int       : unsigned(3 downto 0);
    signal unidades_minuto_alarme_int    : unsigned(3 downto 0);
    signal dezenas_minuto_alarme_int     : unsigned(3 downto 0);

    signal unidades_hora_contador_int    : unsigned(3 downto 0);
    signal dezenas_hora_contador_int     : unsigned(3 downto 0);
    signal unidades_minuto_contador_int  : unsigned(3 downto 0);
    signal dezenas_minuto_contador_int   : unsigned(3 downto 0);
    
    signal saida_mux                      : std_logic_vector(15 downto 0);
    signal selecao_interno                : std_logic := '0';  
begin

    -- SINAIS DE ENTRADA
    dezenas_hora_alarme_int   <= dezena_hora_alarme;
    unidades_hora_alarme_int  <= unidade_hora_alarme; 
    dezenas_minuto_alarme_int <= dezena_minuto_alarme;
    unidades_minuto_alarme_int <= unidade_minuto_alarme;  
    
    dezenas_hora_contador_int  <= dezena_hora_contador; 
    unidades_hora_contador_int <= unidade_hora_contador;  
    dezenas_minuto_contador_int <= dezena_minuto_contador; 
    unidades_minuto_contador_int <= unidade_minuto_contador; 

    -- SAIDA --> FATIAS DE 4 BITS --> DEPENDE DO CONTADOR BINÁRIO
    saida <= saida_mux(15 downto 12) when selecao = "00" else
             saida_mux(11 downto 8)  when selecao = "01" else
             saida_mux(7 downto 4)   when selecao = "10" else
             saida_mux(3 downto 0);

    -- LÓGICA DE SELEÇÃO BASEADA NO BOTÃO DE ALARME
    process(clk, rst, btn_alarme)
    begin
        if rst = '1' then
            selecao_interno <= '0';
        elsif rising_edge(clk) then
            if rising_edge(btn_alarme) then
					if btn_alarme = '1' then
                selecao_interno <= '1';  
            else
                selecao_interno <= '0';  
            end if;
			end if;
        end if;
    end process;

    -- PROCESSO PARA GERAR A SAíDA
    process(clk, rst)
    begin
        if rst = '1' then
            saida_mux <= (others => '0'); 
        elsif rising_edge(clk) then
            if habilita = '1' then
                if selecao_interno = '1' then
                    saida_mux <= std_logic_vector(dezenas_hora_alarme_int & unidades_hora_alarme_int & dezenas_minuto_alarme_int & unidades_minuto_alarme_int); 
                else
                    saida_mux <= std_logic_vector(dezenas_hora_contador_int & unidades_hora_contador_int & dezenas_minuto_contador_int & unidades_minuto_contador_int);
                end if;
            end if;
        end if;
    end process;

end architecture;
