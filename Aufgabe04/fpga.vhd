library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity fpga is
   port(
     rst: in std_logic;
     clk: in std_logic;
     taster : in std_logic;
     
     dioden: out std_logic_vector(14 downto 0);
     blank: out std_logic_vector(34 downto 0);
     Zahl1: out std_logic_vector(6 downto 0);
     Zahl2: out std_logic_vector(6 downto 0);
     Zahl3: out std_logic_vector(6 downto 0);
     Zahl4: out std_logic_vector(6 downto 0)  
     
    );
 end fpga;
 
architecture test of fpga is
signal int_bcd: std_logic_vector(15 downto 0);
signal int_taster : std_logic;
begin
  
  detector2: entity work.fld01 port map (clk, rst,taster , int_taster );
    
  zahler: entity work.ReaktionsTaster port map(rst, clk, int_taster , dioden, int_bcd);
  show1: entity work.anzeige port map( int_bcd(15 downto 12), Zahl1);
  show2: entity work.anzeige port map( int_bcd(11 downto 8), Zahl2);
  show3: entity work.anzeige port map( int_bcd(7 downto  4), Zahl3);
  show4: entity work.anzeige port map( int_bcd(3 downto 0), Zahl4);
  
  blank <=(others =>'1');
  
  
    
    
    ---------------------blank schaltet die zahl aus blank( others => 0) blank (34 downto 0)
end test;