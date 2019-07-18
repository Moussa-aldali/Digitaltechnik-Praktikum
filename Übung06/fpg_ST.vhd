library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fpg_ST is
   port(
     rst: in std_logic;
     FB, LS, KL, KR: in std_logic;
     clk: in std_logic;
     zeiger: out std_logic_vector(6 downto 0);
     ML, MR, ledKR, ledKL, ledG8, ledL, ledR, enable : out std_logic
     
    );
 end fpg_ST;
 
architecture arch of fpg_ST is 
signal int_fb : std_logic;
signal int_kr, int_kl, int_ls: std_logic;
signal zustand: std_logic_vector(3 downto 0);

begin
  detector: entity work.fld01 port map (clk, rst, FB, int_fb); 
  wandRechts: entity work.fld01 port map (clk, rst, KR, int_kr); 
  wandLinks: entity work.fld01 port map (clk, rst, KL, int_kl);
    
   
   
  ST: entity work.SchiebeTor port map (clk,rst,int_fb,int_kr, int_kl,LS, ML, MR, ledKR, ledKL,enable,ledR, ledL, ledG8,zustand );
  z: entity work.siebenSegment port map(zustand, zeiger);
    
end arch;



