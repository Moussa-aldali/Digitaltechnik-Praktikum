library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity zaehler_tb is 

end zaehler_tb;



architecture arch of zaehler_tb is 

signal number: std_logic_vector(3 downto 0);

signal clk : std_logic := '0';

signal load,rst,vr , en : std_logic;

signal cnt_out : std_logic_vector(3 downto 0);

begin

dut : entity work.zaehler port map( number, clk, load, rst ,vr);



number <= "0111";

clk <=  clk after 10 ns; 

load <= '1' after 20 ns, 
        '0' after 67 ns;
en <=   '1' after 30 ns;
vr <=   '1' after 80 ns;

rst <= '1' after 2 ns ,
       '0' after 50 ns ;

end arch;