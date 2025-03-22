library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador is
    port
    (
        dezena_hora_alarme     : in unsigned(3 downto 0);         
        unidade_hora_alarme    : in unsigned(3 downto 0);         
        dezena_minuto_alarme   : in unsigned(3 downto 0);        
        unidade_minuto_alarme  : in unsigned(3 downto 0);        

        dezena_hora_contador   : in unsigned(3 downto 0);         
        unidade_hora_contador  : in unsigned(3 downto 0);         
        dezena_minuto_contador : in unsigned(3 downto 0);        
        unidade_minuto_contador: in unsigned(3 downto 0);        

        habilita    : in std_logic;                    -- Habilita a comparao se ativo
        rst         : in std_logic;                    -- Sinal de reset assncrono
        saida_comp  : out std_logic                    -- Sada do comparador
    );
end entity;

architecture simples of comparador is
begin

    process(rst, dezena_hora_alarme, dezena_hora_contador, unidade_hora_alarme, unidade_hora_contador, dezena_minuto_alarme, dezena_minuto_contador, unidade_minuto_alarme, unidade_minuto_contador, habilita)
    begin
        if rst = '1' then
            saida_comp <= '0';
        elsif habilita = '1' then
            if (dezena_hora_alarme = dezena_hora_contador)   and 
               (unidade_hora_alarme = unidade_hora_contador) and 
               (dezena_minuto_alarme = dezena_minuto_contador) and 
               (unidade_minuto_alarme = unidade_minuto_contador) then
                saida_comp <= '1';
            else
                saida_comp <= '0';
            end if;
        else
            saida_comp <= '0';         
        end if;
    end process;

end architecture;
