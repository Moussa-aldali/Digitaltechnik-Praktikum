library ieee;
use ieee.std_logic_1164.all;

entity zeiger is
  port(
     x: in std_logic_vector (4 downto 0);
     segments: out std_logic_vector (6 downto 0));
 end zeiger;
 
architecture behavior of zeiger is
begin
 with x select
  segments <= "0000001" when "00000",------0
              "1001111" when "00001",------1
              "0010010" when "00010",------2
              "0000110" when "00011",-------3
              "1001100" when "00100",------4
              "0100100" when "00101",------5
              "0100000" when "00110",------6
              "0001101" when "00111",-------7
              "0000000" when "01000",-------8
              "0000100" when "01001",-------9
              "0011000" when "01010",------P---10
              "0001001" when "01011",------N---11
              "0110001" when "01100",------C---12
              "1000010" when "01101",-------d---13
              "0110000" when "01110",-------E---14
              "1111010" when "01111",------r----15
              "1110001" when "10000",-------l---16
              "0110110" when "10001",------3 Balken----17
              "1111111" when others;-------18
            
end behavior;

