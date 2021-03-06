
library ieee;
use ieee.std_logic_1164.all;

entity fld01 is
  port(
    ck, rst, x : in std_logic;
    y: out std_logic);
  end entity;

architecture arch of fld01 is
  type state_type is (zero,flanke,eins);
    signal state: state_type;
begin
  process 
  begin 
  wait until rising_edge(ck);
  case state is 
    when zero => 
      if x = '1' then 
        state <=flanke;
      end if;   
    when flanke =>
      if x = '1' then 
      state <= eins;
    elsif x = '0' then 
        state <= zero;
      end if;
    when eins =>
      if x = '0' then
        state <= zero;
      end if;
  end case;
  if rst = '1' then 
    state <= zero;
    end if; 
  end process;
        
    y <= '1' when state = flanke else '0';
    
  end arch;
       