library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity count is 
   port ( number : in std_logic_vector(3 downto 0);
          clk  : in std_logic;
          load : in std_logic;
          rst : in std_logic;
          vr: in std_logic;
          cnt_out : out std_logic_vector(3 downto 0);
     
   end count;
   
architecture arch of count is 
constant CONST1S:    integer := 50000000 -1;
signal cnt:          integer range 0 to CONST1S;
signal en:           std_logic; 
signal cnt_2:        std_logic_vector(3 downto 0);  
begin  
  
 
  takt: process begin
    wait until rising_edge(clk);
    if cnt = CONST1S then 
      cnt <= 0;
      en <= '1';
    else
      cnt <=cnt + 1;
      en <= '0';
    end if;
  end process;
  
count : process
begin 
  wait until rising_edge(clk);
  if en = '1' then 
    if load = '0' then 
        if vr = '0' then
             cnt_2 <= std_logic_vector(unsigned(cnt_2) +1 );
         else 
              cnt_2 <= std_logic_vector(unsigned(cnt_2)- 1); 
          end if; 
    else
           cnt_2 <= number; 
    end if; 
 end if ;
 if rst = '1' then 
      cnt_2 <= (others =>'0'); -- oder "0000" 
 end if ; 
         
end process ;
  cnt_out<=cnt_2 ;
 
end arch;