library IEEE;
USE IEEE.STD_LOGIC_1164.ALL ; 

ENTITY tb_fld10 is 
end ENTITY;

architecture arch of tb_fld10 is 

signal ck: std_logic :='0';
signal x: std_logic  :='0';
signal rst : std_logic :='0';
signal y: std_logic :='0';

begin 
dut: ENTITY work.fld10 port map (ck , rst , x , y );
ck <= not ck after 10 ns ;
x <= not x after 28 ns ; 

end arch ;