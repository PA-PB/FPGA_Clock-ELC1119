library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_BCD is
    port (
        unidade_hora_C     : out unsigned(3 downto 0);  -- Saída para as unidades de hora
        dezena_hora_C      : out unsigned(3 downto 0);  -- Saída para as dezenas de hora
        unidade_minuto_C   : out unsigned(3 downto 0);  -- Saída para as unidades de minuto
        dezena_minuto_C    : out unsigned(3 downto 0);  -- Saída para as dezenas de minuto
        habilita           : in  std_logic;             -- Habilita a contagem automática se ativo
        btn_incrementa_H   : in  std_logic;             -- Sinal para incrementar a hora manualmente
        btn_incrementa_M   : in  std_logic;             -- Sinal para incrementar o minuto manualmente
        clk                : in  std_logic;             -- Sinal de clock principal
        rst                : in  std_logic;             -- Sinal de reset assíncrono
        btn_alarme         : in  std_logic              -- Sinal de btn_alarme para inibir incrementos manuais
    );
end entity;

architecture simples of contador_BCD is
    signal unidade_hora_int       : unsigned(3 downto 0);
    signal dezena_hora_int        : unsigned(3 downto 0);
    signal unidade_minuto_int     : unsigned(3 downto 0);
    signal dezena_minuto_int      : unsigned(3 downto 0);
    
    signal clk_1Hz       : std_logic := '0';  -- Clock de 1Hz para incremento automático
    signal clk_1min      : std_logic := '0';  -- Clock de 1 minuto

    -- Sinais auxiliares para os divisores de frequência
    signal contador_clk_1Hz  : unsigned(26 downto 0) := (others => '0');
    signal contador_clk_1min : unsigned(15 downto 0) := (others => '0');
    
    -- Sinais para detectar a borda de subida dos botões
    signal prev_btn_incrementa_H : std_logic := '0';
    signal prev_btn_incrementa_M : std_logic := '0';

    -- Sinal para verificar se é necessário resetar para 00:00
    signal reset_to_zero : std_logic;

begin

    -- Divisor de frequência para gerar 1Hz (assumindo um clock de 100MHz)
    process (clk, rst)
    begin
        if rst = '1' then
            contador_clk_1Hz <= (others => '0');
            clk_1Hz <= '0';
        elsif rising_edge(clk) then
            if contador_clk_1Hz =  2 - 1 then  -- 50 milhões para 1Hz
                clk_1Hz <= not clk_1Hz;
                contador_clk_1Hz <= (others => '0');
            else
                contador_clk_1Hz <= contador_clk_1Hz + 1;
            end if;
        end if;
    end process;

    -- Divisor de frequência para gerar clock de 1 minuto (assumindo 1Hz como entrada)
    process (clk_1Hz, rst)
    begin
        if rst = '1' then
            contador_clk_1min <= (others => '0');
            clk_1min <= '0';
        elsif rising_edge(clk_1Hz) then
            if contador_clk_1min = 5 then  -- 59 segundos para gerar 1 minuto
                clk_1min <= not clk_1min;
                contador_clk_1min <= (others => '0');
            else
                contador_clk_1min <= contador_clk_1min + 1;
            end if;
        end if;
    end process;

    
    reset_to_zero <= '1' when (unidade_hora_int = 3 and dezena_hora_int = 2 and unidade_minuto_int = 9 and dezena_minuto_int = 5) else '0';

    -- Processo de contagem de minutos
    process (clk_1min, btn_incrementa_M, rst)
    begin
        if rst = '1' or reset_to_zero = '1' then
            unidade_minuto_int <= (others => '0');
            dezena_minuto_int <= (others => '0');
        elsif rising_edge(clk_1min) or (btn_incrementa_M = '1' and prev_btn_incrementa_M = '0') then
            if habilita = '1' then
                if unidade_minuto_int = 9 then
                    unidade_minuto_int <= (others => '0');
                    if dezena_minuto_int = 5 then
                        dezena_minuto_int <= (others => '0');
                    else
                        dezena_minuto_int <= dezena_minuto_int + 1;
                    end if;
                else
                    unidade_minuto_int <= unidade_minuto_int + 1;
                end if;
            end if;
        end if;
    end process;

    -- Processo de contagem de horas
    process (clk_1min, btn_incrementa_H, rst)
    begin
        if rst = '1' or reset_to_zero = '1' then
            unidade_hora_int <= (others => '0');
            dezena_hora_int <= (others => '0');
        elsif rising_edge(clk_1min) or (btn_incrementa_H = '1' and prev_btn_incrementa_H = '0') then
            if (unidade_minuto_int = 0 and dezena_minuto_int = 0) or 
               (btn_incrementa_H = '1' and prev_btn_incrementa_H = '0') then
                if unidade_hora_int = 9 then
                    unidade_hora_int <= (others => '0');
                    if dezena_hora_int = 2 and unidade_hora_int = 3 then
                        dezena_hora_int <= (others => '0');
                    else
                        dezena_hora_int <= dezena_hora_int + 1;
                    end if;
                else
                    unidade_hora_int <= unidade_hora_int + 1;
                end if;
            end if;
        end if;
    end process;

    -- Atualiza os sinais anteriores para detectar bordas de subida
    process (clk)
    begin
        if rising_edge(clk) then
            prev_btn_incrementa_H <= btn_incrementa_H;
            prev_btn_incrementa_M <= btn_incrementa_M;
        end if;
    end process;

    -- Outputs
    unidade_hora_C   <= unidade_hora_int;
    dezena_hora_C    <= dezena_hora_int;
    unidade_minuto_C <= unidade_minuto_int;
    dezena_minuto_C  <= dezena_minuto_int;

end architecture;
