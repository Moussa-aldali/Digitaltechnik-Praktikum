library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fpga_dreher is
   port(
     a, b : in std_logic;
     rst : in std_logic;
     clk: in std_logic;
     load : in std_logic ; 
     nummer : in std_logic_vector(3 downto 0);
     ledsig: in std_logic;
     segments: out std_logic_vector(6 downto 0);
     dioden: out std_logic_vector(14 downto 0)
     
    );
 end fpga_dreher;
 
architecture arch of fpga_dreher is 
signal y: std_logic_vector(1 downto 0);
signal int_a: std_logic;
signal vr, en: std_logic;
signal speicher: std_logic;
signal cout: std_logic_vector(3 downto 0);
signal int_led : std_logic;

begin


  vr <=  '1' when y = "10" else
  '0';                                                                                                                                                                     
en <= '0' when y = "00" and load = '0' else
  '1';

  detector: entity work.fld01 port map (clk, rst, a, int_a);   
  drehgeber: entity work.encoderr port map(int_a,b, y);
  zahler: entity work.count port map (en, nummer, clk, load, rst, vr, cout);
  zeigen: entity work.anzeige port map( cout, segments);
  detectorZwei: entity work.fld01 port map (clk, rst,ledsig, int_led);

  process
    begin
      wait until rising_edge(clk);
      if int_led = '1' then
        speicher<= not speicher;
      end if;
      if speicher = '0' then
        case cout is
          when x"0" => dioden <= "000000000000000";
          when x"1" => dioden <= "000000000000001";
          when x"2" => dioden <= "000000000000011";
          when x"3" => dioden <= "000000000000111";
          when x"4" => dioden <= "000000000001111";
          when x"5" => dioden <= "000000000011111";
          when x"6" => dioden <= "000000000111111";
          when x"7" => dioden <= "000000001111111";
          when x"8" => dioden <= "000000011111111";
          when x"9" => dioden <= "000000111111111";
          when x"A" => dioden <= "000001111111111";
          when x"B" => dioden <= "000011111111111";
          when x"C" => dioden <= "000111111111111";
          when x"D" => dioden <= "001111111111111";
          when x"E" => dioden <= "011111111111111";
          when others =>dioden <= "111111111111111";
        end case;
      end if;
      if speicher ='1' then
        case cout is
          when x"0" => dioden <= "000000000000000";
          when x"1" => dioden <= "000000000000001";
          when x"2" => dioden <= "000000000000010";
          when x"3" => dioden <= "000000000000100";
          when x"4" => dioden <= "000000000001000";
          when x"5" => dioden <= "000000000010000";
          when x"6" => dioden <= "000000000100000";
          when x"7" => dioden <= "000000001000000";
          when x"8" => dioden <= "000000010000000";
          when x"9" => dioden <= "000000100000000";
          when x"A" => dioden <= "000001000000000";
          when x"B" => dioden <= "000010000000000";
          when x"C" => dioden <= "000100000000000";
          when x"D" => dioden <= "001000000000000";
          when x"E" => dioden <= "010000000000000";
          when others => dioden <= "100000000000000";
          end case;
        end if;
      end process;
  
     
end arch;
