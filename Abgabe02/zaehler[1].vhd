library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity zaehler is 
port ( number : in std_logic_vector(3 downto 0);
clk  : in std_logic;
load : in std_logic;
       rst : in std_logic;
      enable : in std_logic;
      
       cnt_out : out std_logic_vector(3 downto 0));
     
   end zaehler;
   
    architecture arch of zaehler is 
     
signal   cnt:  std_logic_vector(3 downto 0);
begin
  process(number, clk, load, rst, enable,cnt)
    begin
      if rising_edge(clk) then 
        if enable = '1' then 
          if load = '1' then cnt <= number;
          elsif load = '0'  then 
              if number = "0000" then cnt <= cnt+"0001";
              elsif number > "0000" then cnt <= cnt-"0001";
              end if;
          end if;
          if rst ='1' then cnt <= number;     
          end if; 
        end if;
      end if;
      cnt_out<=cnt;
      
  end process;
end arch;