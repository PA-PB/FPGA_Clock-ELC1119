library ieee;
use ieee.std_logic_1164.all;

entity controlador_display is
    port (
        digitos          : in  std_logic_vector(3 downto 0);                    
        selecao          : in  std_logic_vector(1 downto 0);                  
        saida_7seg       : out std_logic_vector(6 downto 0);   
        an               : out std_logic_vector(3 downto 0)   
    );
end entity;

architecture behavior of controlador_display is
begin

    process(selecao)
    begin
        case selecao is
            when "00" => an <= "1110"; 
            when "01" => an <= "1101"; 
            when "10" => an <= "1011"; 
            when "11" => an <= "0111";
            when others => an <= "1111"; -- Desligar todos os displays (caso de erro)
        end case;
    end process;

    process(digitos)
    begin
        case digitos is                 --gfedcba
            when "0000" => saida_7seg <= "1000000"; -- 0
            when "0001" => saida_7seg <= "1111001"; -- 1
            when "0010" => saida_7seg <= "0100100"; -- 2
            when "0011" => saida_7seg <= "0110000"; -- 3
            when "0100" => saida_7seg <= "0011001"; -- 4
            when "0101" => saida_7seg <= "0010010"; -- 5
            when "0110" => saida_7seg <= "0000010"; -- 6
            when "0111" => saida_7seg <= "1111000"; -- 7
            when "1000" => saida_7seg <= "0000000"; -- 8
            when "1001" => saida_7seg <= "0010000"; -- 9
            when others => saida_7seg <= "1111111"; -- Apagar todos os segmentos (caso de erro)
        end case;
    end process;

end architecture;
