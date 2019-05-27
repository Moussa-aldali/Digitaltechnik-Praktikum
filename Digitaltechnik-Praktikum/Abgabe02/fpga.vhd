library ieee;
use ieee.std_logic_1164.all;

entity fpga is 
port (
	 number: in std_logic_vector (3 downto 0);
	 ck, rst , load , vr : in std_logic;     
	 segments: out std_logic_vector (6 downto 0));
end fpga;
architecture arch of fpga is 
signal cnt_out_o : std_logic_vector(3 downto 0); 

begin 
counter  : entity work.count (arch) port map (number, ck , load , rst ,vr , cnt_out_o );
Anzeiger : entity work.Anzeige (behavior ) port map(cnt_out_o,segments);
end arch ; 