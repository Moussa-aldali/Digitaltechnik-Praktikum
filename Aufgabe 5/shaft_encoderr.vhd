Library IEEE; 
Use IEEE.Std_Logic_1164.all; 
 
entity shaft_encoderr is port 
   (  
     A   : in    std_logic; 
     B   : in    std_logic; 
     Aus : out std_logic_vector(1 downto 0)
   ); 
end shaft_encoderr; 
 
architecture arch of shaft_encoderr is 
 
begin 
Aus <=  "10" when A = '1' and B = '1' else
        "01" when A = '1' and B = '0' else
        "00"; 
         
end arch; 