library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTRADOR_ALARME is
    port
    (
        unidade_hora_A     : out unsigned(3 downto 0);         -- Sada para as unidades de hora
        dezena_hora_A      : out unsigned(3 downto 0);         -- Sada para as dezenas de hora
        unidade_minuto_A   : out unsigned(3 downto 0);         -- Sada para as unidades de minuto
        dezena_minuto_A    : out unsigned(3 downto 0);         -- Sada para as dezenas de minuto
        habilita         : in std_logic;                     -- habilita a contagem automtica se ativo
        btn_incrementa_hora  : in std_logic;                     -- sinal para incrementar a hora manualmente
        btn_incrementa_minuto: in std_logic;                     -- sinal para incrementar o minuto manualmente
        rst              : in std_logic;                     -- sinal de reset assncrono
        btn_alarme           : in std_logic                      -- sinal de btn_alarme para inibir incrementos manuais
    );
end entity;

architecture simples of REGISTRADOR_ALARME is
    signal unidade_hora_int    : unsigned(3 downto 0) := (others => '0');
    signal dezena_hora_int     : unsigned(3 downto 0) := (others => '0');
    signal unidade_minuto_int  : unsigned(3 downto 0) := (others => '0');
    signal dezena_minuto_int   : unsigned(3 downto 0) := (others => '0');
begin

    unidade_hora_A   <= unidade_hora_int;
    dezena_hora_A    <= dezena_hora_int;
    unidade_minuto_A <= unidade_minuto_int;
    dezena_minuto_A  <= dezena_minuto_int;

    process (rst, btn_incrementa_minuto, btn_incrementa_hora, unidade_hora_int, dezena_hora_int, unidade_minuto_int, dezena_minuto_int, habilita)
    begin
        if rst = '1' then
            unidade_hora_int    <= (others => '0');
            dezena_hora_int     <= (others => '0');
            unidade_minuto_int  <= (others => '0');
            dezena_minuto_int   <= (others => '0');
 
        else
            if dezena_hora_int = 2 and unidade_hora_int = 3 and dezena_minuto_int = 5 and unidade_minuto_int = 9 then
                unidade_hora_int    <= (others => '0');
                dezena_hora_int     <= (others => '0');
                unidade_minuto_int  <= (others => '0');
                dezena_minuto_int   <= (others => '0');
            else
                --INCREMENTO MANUAL DOS MINUTOS
                if rising_edge(btn_incrementa_minuto) then
                    if btn_alarme = '1' then
                        if unidade_minuto_int = 9 then
                            unidade_minuto_int <= (others => '0');
                            if dezena_minuto_int = 5 then
                                dezena_minuto_int <= (others => '0');
                                -- QUANDO MINUTOS = 59 --> HORAS + 1
                                if unidade_hora_int = 9 then
                                    unidade_hora_int <= (others => '0');
                                    if dezena_hora_int = 2 then
                                        -- RESET QUANDO 23
                                        dezena_hora_int <= (others => '0');
                                    else
                                        dezena_hora_int <= dezena_hora_int + 1;
                                    end if;
                                else
                                    unidade_hora_int <= unidade_hora_int + 1;
                                end if;
                            else
                                dezena_minuto_int <= dezena_minuto_int + 1;
                            end if;
                        else
                            unidade_minuto_int <= unidade_minuto_int + 1;
                        end if;
                    end if;
                end if;
                -- INCREMENTO MANUAL DAS HORAS
                if rising_edge(btn_incrementa_hora) then
                    if btn_alarme = '1' then
                        if (dezena_hora_int = 2 and unidade_hora_int = 3) then
                            -- QUANDO HORAS = 23 --> RESET
                            unidade_hora_int <= (others => '0');
                            dezena_hora_int <= (others => '0');
                        else
                            if unidade_hora_int = 9 then
                                unidade_hora_int <= (others => '0');
                                dezena_hora_int <= dezena_hora_int + 1;
                            else
                                unidade_hora_int <= unidade_hora_int + 1;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture;