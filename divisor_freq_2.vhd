library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_div_240Hz is
    port (
        clk_in     : in  std_logic;      
        rst        : in  std_logic;     
        clk_div_2  : out std_logic   
    );
end entity;

architecture behavior of freq_div_240Hz is
    signal counter : unsigned(12 downto 0) := (others => '0'); -- 20-bit counter (0 to 999,999)
    signal clk_div : std_logic := '0';  -- Internal clock divider signal
begin
    process(clk_in, rst)
    begin
        if rst = '1' then
            counter <= (others => '0');
            clk_div <= '0';
        elsif rising_edge(clk_in) then
            if counter = 6_926 - 1 then 
                counter <= (others => '0');   
                clk_div <= not clk_div; 
            else
                counter <= counter + 1; 
            end if;
        end if;
    end process;

    clk_div_2 <= clk_div;  -- Output the divided clock

end architecture;