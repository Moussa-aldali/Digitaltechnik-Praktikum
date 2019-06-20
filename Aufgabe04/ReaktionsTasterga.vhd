library library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigend.all ; 

entity ReaktionsTaster is
    port (
        rst : in std_logic ;
        clk : in std_logic ;
        taster : in std_logic;
        dioden : out std_logic_vector (14 downto 0);
        dcb : out std_logic_vector(15 downto 0);
    );
end entity ReaktionsTaster;


architecture arch of ReaktionsTaster is
signal uhr_rst, uhr_on , speicher : std_logic
signal einer , zehn , hundert , tausend : integer ;
signal led : std_logic ;
signal sek : integer;
signal hund : integer;
type state_type is (init , start , result , warte , message );
signal state : state_type;
type state_type is (zero , flanke , eins);
signal flanke_state : state_type;
signal en : std_logic ;
Constant CONST1S : integer := 50000 -1 ; 
signal cnt : integer range 0 to CONST1S;
signal error : std_logic :=0;
    
begin

---------------------takteiler--------------------------------
takteiler: process 
begin
wait until rising_edge(clk)
if cnt = CONST1S then 
    cnt <= 0;
    en <= '1';
else 
    cnt <= cnt+1 ;
    en <= '0';
    end if ;
end process;
---------------------end takteiler-----------------------------
---------------------BCD uhr-----------------------------------
bcd_uhr : process
begin
wait until rising_edge(clk)
if uhr_on = '1';then 
 if en = '1' then 
    if zehn = 9 then 
        zehn <= 0 ;
         if hundert = 9 then
            hundert <= 0 ; 
            if tausend = 9 then 
            tausend <= 0 ;
            else tausend <= tausend +1 ; 
            end if ; 
            else hundert <= hundert +1 ;
            end if ;
            else zehn <= zehn +1 ; 
            end if ; 
        end if ; 
    end if ; 
    end if ;
    if uhr_rst ='1' or rst='1' then 
    einer   <=0;
    zehn    <=0;
    hundert <=0;
    tausend <=0;
    end if ; 
    end process;

--------------------- End BCD uhr----------------------------------
---------------------LED Muster------------------------------------
decoder: process
begin 
wait until rising_edge(clk);
 if state = warte then 
    case tausend is 
      when 0 => dioden <= "101010101010101";
            when 1 => dioden <= "110110110110110";
            when 2 => dioden <= "111011101110111";
            when 3 => dioden <= "011011010101101";
            when 4 => dioden <= "101010000101110";
            when 5 => dioden <= "101110111011101";
            when 6 => dioden <= "110111111101000";
            when 7 => dioden <= "101001010111110";
            when 8 => dioden <= "101010101110101";
            when others => dioden <= "101011101110101";
          end case;
          if rst = '1' then 
          led <='0';
          end if;
          elsif  state = init then
          dioden <="000000000000000"
          else 
          dioden <="111111111111111"
          end if ;
          end process;
--------------------- LED Muster End----------------------------------
--------------------- init Anfang-------------------------------------

process 
begin wait until rising_edge(clk)
case state is 
when init => 
dcb <="0000000000000000"  -- ergebnisanzeige 
uhr_on <='1'; --uhr Start 
uhr_rst <='0'; 
error <='0';
led <= '0'; --LED off 
if taster = '1' then 
 state <= start;
 end if ; 
--------------------- init Ende---------------------------------------
--------------------- stare Anfang------------------------------------

when start => 
uhr_on <= '0';
case hundert is 
    when 0 => 
        sek <= 1 ; hund <= 5 ;-- Zufallzeit 
    when 1 => 
        sek <= 1 ; hund <=  8;
    when 2 => 
        sek <= 2 ; hund <= 1 ; 
    when 3 =>
        sek <= 2 ; hund <= 4 ; 
    when 4 =>
         sek <= 2 ; hund = 7 ; 
    when 5 => 
        sek <= 7; hund <= 2;
    when 6 => 
        sek <= 8; hund <= 4;
    when 7 => 
        sek <= 9; hund <= 6;
    when 8 => 
         sek <= 1; hund <= 2;
    when others =>
         sek <= 2; hund <= 4;
    end case ; 
    uhr_rst <='1';
    start <= warte;
--------------------- Start Ende-------------------------------------------
--------------------- Warte Anfang-----------------------------------------
when warte =>
uhr_rst <= '0';
uhr_on  <= '1';
led <='1';
if taster = '1' then 
    uhr_on <='0';
    error <= '1';
    state <= result;
    end if ;
    if einer = sek and zehn = hund then 
    uhr_rst <='1';
    state <= message;
end if ;
---------------------  Warten ende-------------------------------------------
--------------------- message Anfang-----------------------------------------

when message => 
uhr_rst <='0'
led <='0';
if einer = 9 and zehn = 9 and hundert = 9 and tausend = 9 then 
error <= '1'
 state <= result;
 end if ;
 if taster = '1' then 
 state <= result;
 end if ;
 --------------------- message ende-------------------------------------------
--------------------- result Anfang-------------------------------------------
when result => 
uhr_on <= '0';
if error = '0' then 
      dcb(15 downto 12) <= std_logic_vector(to_unsigned(einer,4));
      dcb(11 downto 8) <= std_logic_vector(to_unsigned(zehn,4));
      dcb(7 downto 4) <= std_logic_vector(to_unsigned(hundert,4));
      dcb(3 downto 0) <= std_logic_vector(to_unsigned(tausend,4));

      else 

      dcb(15 downto 12) <="1111";
      dcb(11 downto 8) <= "1111";
      dcb(7 downto 4) <= "1111";
      dcb(3 downto 0) <= "1111";
      end if;
      if taster = '1' then 
      state= init ;

      end if ;
--------------------- result ende und Anfang init---------------------------------------------

end case ;
if rst = '1' then 
state <= init ;
end if;
end process;
end architecture arch;