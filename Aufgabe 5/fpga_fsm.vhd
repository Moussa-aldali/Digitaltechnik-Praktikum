library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fpga_fsm is
   port(
     rst: in std_logic;
     clk: in std_logic;
     taste: in std_logic;
     a,b : in std_logic;
     
     dioden: out std_logic_vector(17 downto 0);
     zeiger0, zeiger1, zeiger2, zeiger3: out std_logic_vector(6 downto 0);
	  blank: out std_logic_vector(35 downto 0)
     
    );
 end fpga_fsm;
 
architecture arch of fpga_fsm is 
signal int_a : std_logic;
constant CONST05: integer:= 100000000 -1;
signal cnt05: integer range 0 to CONST05;
signal dreher : std_logic_vector(1 downto 0);
signal ledsig : std_logic;
signal int_ledsig : std_logic;
signal int_s0, int_s1, int_s2, int_s3: std_logic_vector(4 downto 0);

begin
  detector: entity work.fld01 port map (clk, rst, a, int_a);  
  tst: entity work.fld01 port map (clk,rst,taste,ledsig); 
  drehgeber: entity work.shaft_encoderr port map(int_a,b, dreher);
  safe: entity work.safe port map (clk,rst,ledsig,dreher,int_s0, int_s1,int_s2,int_s3,dioden);
  z0: entity work.zeiger port map(int_s0, zeiger0);
  z1: entity work.zeiger port map(int_s1, zeiger1);
  z2: entity work.zeiger port map(int_s2, zeiger2);
  z3: entity work.zeiger port map(int_s3, zeiger3);
  blank<="111111111111111111111111111111111111";
    
end arch;


