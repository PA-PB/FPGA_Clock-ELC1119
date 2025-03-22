library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.meu_sistema_pkg.all;

entity sistema_top is
    port (
        clk                     : in  std_logic;
        rst                     : in  std_logic;
        botao_incrementa_hora   : in  std_logic;
        botao_incrementa_minuto : in  std_logic;
        botao_liga_desliga            : in  std_logic;
        botao_alarme                  : in  std_logic;
        saida_7seg_placa              : out std_logic_vector(6 downto 0);
        an_placa                      : out std_logic_vector(3 downto 0);
        led_L1_placa                  : out std_logic;
        led_L2_placa                  : out std_logic
    );
end sistema_top;

architecture behavior of sistema_top is

    signal clk_div_1Hz, clk_div_240Hz : std_logic;
    signal selecao_topo               : std_logic_vector(1 downto 0);
    signal debounced_hora             : std_logic;
    signal debounced_minuto           : std_logic;
    signal debounced_alarme           : std_logic;
    signal debounced_liga_desliga     : std_logic;
    signal dezena_hora_A_topo, unidade_hora_A_topo, dezena_minuto_A_topo, unidade_minuto_A_topo : unsigned(3 downto 0);
    signal dezena_hora_C_topo, unidade_hora_C_topo, dezena_minuto_C_topo, unidade_minuto_C_topo : unsigned(3 downto 0);
    signal saida_comp_topo           : std_logic;
    signal saida_mux_topo            : std_logic_vector(3 downto 0);

begin

    u_freq_div_1Hz: freq_div_1Hz
        port map (
            clk_in    => clk,
            rst       => rst,
            clk_div_1 => clk_div_1Hz
        );

    u_freq_div_240Hz: freq_div_240Hz
        port map (
            clk_in    => clk,
            rst       => rst,
            clk_div_2 => clk_div_240Hz
        );

    u_contador_binario: contador_binario
        port map (
            clk_div_2    => clk_div_240Hz,
            rst          => rst,
            habilita     => '1', 
            saida_cont_bin => selecao_topo
        );

    u_debounce_hora: debounce
        port map (
            clk     => clk,
            reset   => rst,
            button  => botao_incrementa_hora,
            result  => debounced_hora
        );

    u_debounce_minuto: debounce
        port map (
            clk     => clk,
            reset   => rst,
            button  => botao_incrementa_minuto,
            result  => debounced_minuto
        );
    
    u_debounce_alarme: debounce
        port map (
            clk     => clk,
            reset   => rst,
            button  => botao_alarme,
            result  => debounced_alarme
        );   

    u_debounce_lig: debounce
        port map (
            clk     => clk,
            reset   => rst,
            button  => botao_liga_desliga,
            result  => debounced_liga_desliga
        );

    u_contador_BCD: contador_BCD
        port map (
            unidade_hora_C      => unidade_hora_C_topo,
            dezena_hora_C       => dezena_hora_C_topo,
            unidade_minuto_C    => unidade_minuto_C_topo,
            dezena_minuto_C     => dezena_minuto_C_topo,
            habilita            => '1',  
            btn_incrementa_hora   => debounced_hora,
            btn_incrementa_minuto => debounced_minuto,
            clk_div           => clk_div_1Hz,
            rst               => rst,
            btn_alarme     => debounced_alarme
        );

    u_REGISTRADOR_ALARME: REGISTRADOR_ALARME
        port map (
            unidade_hora_A      => unidade_hora_A_topo,
            dezena_hora_A       => dezena_hora_A_topo,
            unidade_minuto_A    => unidade_minuto_A_topo,
            dezena_minuto_A     => dezena_minuto_A_topo,
            habilita            => '1', o
            btn_incrementa_hora   => debounced_hora,
            btn_incrementa_minuto => debounced_minuto,
            rst               => rst,
            btn_alarme        => debounced_alarme
        );

    u_comparador: comparador
        port map (
            dezena_hora_alarme     => dezena_hora_A_topo,
            unidade_hora_alarme    => unidade_hora_A_topo,
            dezena_minuto_alarme   => dezena_minuto_A_topo,
            unidade_minuto_alarme  => unidade_minuto_A_topo,
            dezena_hora_contador   => dezena_hora_C_topo,
            unidade_hora_contador  => unidade_hora_C_topo,
            dezena_minuto_contador => dezena_minuto_C_topo,
            unidade_minuto_contador => unidade_minuto_C_topo,
            habilita               => '1',  
            rst                    => rst,
            saida_comp             => saida_comp_topo
        );

    u_alarme: controle_alarme
        port map (
            clk          => clk_div_1Hz,
            rst          => rst,
            comparador   => saida_comp_topo,
            btn_liga_desliga => debounced_liga_desliga,
            led_L1       => led_L1_placa,
            led_L2       => led_L2_placa,
            btn_alarme   => debounced_alarme
        );

    u_mux_selecao: mux_selecao
        port map (
            dezena_hora_alarme     => dezena_hora_A_topo,
            unidade_hora_alarme    => unidade_hora_A_topo,
            dezena_minuto_alarme   => dezena_minuto_A_topo,
            unidade_minuto_alarme  => unidade_minuto_A_topo,
            dezena_hora_contador   => dezena_hora_C_topo,
            unidade_hora_contador  => unidade_hora_C_topo,
            dezena_minuto_contador => dezena_minuto_C_topo,
            unidade_minuto_contador => unidade_minuto_C_topo,
            saida            => saida_mux_topo,
            habilita         => '1', 
            rst              => rst,
            btn_alarme       => debounced_alarme,
            clk              => clk_div_240Hz,
            btn_incrementa_hora  => debounced_hora,
            btn_incrementa_minuto => debounced_minuto,
            selecao          => selecao_topo
        );

    u_controlador_display: controlador_display
        port map (
            digitos  => saida_mux_topo,
            selecao  => selecao_topo,
            saida_7seg => saida_7seg_placa,
            an      => an_placa
        );

end behavior;
