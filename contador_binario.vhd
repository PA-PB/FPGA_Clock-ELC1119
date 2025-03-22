library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_binario is
    port (
        clk_div_2       : in  std_logic;       -- Entrada de clock
        rst             : in  std_logic;       -- Entrada de reset
        habilita        : in  std_logic;       -- Entrada de habilitação
        saida_cont_bin  : out std_logic_vector(1 downto 0)  -- É a selecao do MUX do 7 segmentos 
    );
end entity contador_binario;

architecture behavior of contador_binario is
    
    signal contagem_int : unsigned(1 downto 0) := (others => '0'); -- Sinal interno para a contagem
begin

    process(clk_div_2, rst)
    begin
        if rst = '1' then
            contagem_int <= (others => '0');   -- Reseta a contagem para 0
        elsif rising_edge(clk_div_2) then
            if habilita = '1' then
                if contagem_int = "11" then       -- Verifica se a contagem atingiu "11"
                    contagem_int <= (others => '0'); -- Reseta a contagem para 0
                else
                    contagem_int <= contagem_int + 1;   -- Incrementa a contagem
                end if;
            end if;
        end if;
    end process;

    saida_cont_bin  <= std_logic_vector(contagem_int);  

end architecture;
