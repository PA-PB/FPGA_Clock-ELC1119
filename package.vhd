library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package meu_sistema_pkg is

    component freq_div_1Hz is
        port (
            clk_in  : in  std_logic;
            rst     : in  std_logic;
            clk_div_1 : out std_logic
        );
    end component;

    component contador_binario is
        port (
            clk_div_2   : in  std_logic;      
            rst         : in  std_logic;     
            habilita    : in  std_logic;      
            saida_cont_bin        : out std_logic_vector(1 downto 0)  
        );
    end component;

    component freq_div_240Hz is
        port (
            clk_in    : in  std_logic;
            rst       : in  std_logic;
            clk_div_2 : out std_logic
        );
    end component;

    component controlador_display is
        port (
            digitos  : in  std_logic_vector(3 downto 0);
            selecao  : in  std_logic_vector(1 downto 0);
            saida_7seg : out std_logic_vector(6 downto 0);
            an      : out std_logic_vector(3 downto 0)
        );
    end component;

    component comparador is
        port (
            dezena_hora_alarme     : in unsigned(3 downto 0);         
            unidade_hora_alarme    : in unsigned(3 downto 0);         
            dezena_minuto_alarme   : in unsigned(3 downto 0);        
            unidade_minuto_alarme  : in unsigned(3 downto 0);        
    
            dezena_hora_contador   : in unsigned(3 downto 0);         
            unidade_hora_contador  : in unsigned(3 downto 0);         
            dezena_minuto_contador : in unsigned(3 downto 0);        
            unidade_minuto_contador: in unsigned(3 downto 0);        
    
            habilita    : in std_logic;                    -- Habilita a comparação se ativo
            rst         : in std_logic;                    -- Sinal de reset assíncrono
            saida_comp  : out std_logic                    -- Saída do comparador
        );
    end component;

    component controle_alarme is
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            comparador   : in  std_logic; 
            btn_liga_desliga : in  std_logic; 
            led_L1       : out std_logic; 
            led_L2       : out std_logic;
            btn_alarme : in  std_logic 
        );
    end component;

    component debounce is
        generic (
            clk_freq    : integer := 100_000_000;
            stable_time : integer := 10
        );
        port (
            clk     : in  std_logic;
            reset : in  std_logic;
            button  : in  std_logic;
            result  : out std_logic
        );
    end component;

    component contador_BCD is
        port (
            unidade_hora_C     : out unsigned(3 downto 0);         -- Saída para as unidades de hora
            dezena_hora_C      : out unsigned(3 downto 0);         -- Saída para as dezenas de hora
            unidade_minuto_C   : out unsigned(3 downto 0);         -- Saída para as unidades de minuto
            dezena_minuto_C    : out unsigned(3 downto 0);         -- Saída para as dezenas de minuto
            habilita         : in std_logic;                     -- habilita a contagem automática se ativo
            btn_incrementa_hora  : in std_logic;                     -- sinal para incrementar a hora manualmente
            btn_incrementa_minuto: in std_logic;                     -- sinal para incrementar o minuto manualmente
            clk_div          : in std_logic;                     -- sinal de relógio
            rst              : in std_logic;                     -- sinal de reset assíncrono
            btn_alarme     : in std_logic                      -- sinal de btn_alarme para inibir incrementos manuais
        );
    end component;

    component mux_selecao is
        port (
            dezena_hora_alarme     : in unsigned(3 downto 0);         
            unidade_hora_alarme    : in unsigned(3 downto 0);         
            dezena_minuto_alarme   : in unsigned(3 downto 0);        
            unidade_minuto_alarme  : in unsigned(3 downto 0);        
    
            dezena_hora_contador   : in unsigned(3 downto 0);         
            unidade_hora_contador  : in unsigned(3 downto 0);         
            dezena_minuto_contador : in unsigned(3 downto 0);        
            unidade_minuto_contador: in unsigned(3 downto 0);   
            
            saida            : out std_logic_vector(3 downto 0);
            habilita         : in std_logic;
            rst              : in std_logic;
            btn_alarme           : in std_logic;
            clk              : in std_logic;
            btn_incrementa_hora  : in std_logic;
            btn_incrementa_minuto: in std_logic;
            selecao          : in std_logic_vector(1 downto 0)
        );
    end component;

    component REGISTRADOR_ALARME is
        port (
        unidade_hora_A       : out unsigned(3 downto 0);         -- Saída para as unidades de hora
        dezena_hora_A        : out unsigned(3 downto 0);         -- Saída para as dezenas de hora
        unidade_minuto_A     : out unsigned(3 downto 0);         -- Saída para as unidades de minuto
        dezena_minuto_A      : out unsigned(3 downto 0);         -- Saída para as dezenas de minuto
        habilita             : in std_logic;                     -- habilita a contagem automática se ativo
        btn_incrementa_hora  : in std_logic;                     -- sinal para incrementar a hora manualmente
        btn_incrementa_minuto: in std_logic;                     -- sinal para incrementar o minuto manualmente
        rst                  : in std_logic;                     -- sinal de reset assíncrono
        btn_alarme           : in std_logic                      -- sinal de btn_alarme para inibir incrementos manuais
        );
    end component;

end package meu_sistema_pkg;
