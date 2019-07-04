library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Safe is
  port (
    clk, rst, taste: in std_logic;
    dreher: in std_logic_vector(1 downto 0);
    s0, s1, s2, s3: out std_logic_vector(4 downto 0);
    dioden: out std_logic_vector(17 downto 0));
  end entity;
  
  architecture arch of Safe is
    signal en: std_logic;
    signal int_s0, int_s1, int_s2, int_s3 : integer range 0 to 18;
    signal c0, c1, c2, c3: integer range 0 to 9;

    constant CONST01: integer:= 11111111-1;
    constant CONST05: integer:= 25000000 -1;
    constant CONST2: integer:=  100000000 -1;
    constant led: integer:=8;
	 signal int_taste: std_logic;
    signal cnttkt: integer range 0 to CONST01;
    signal cnt05: integer range 0 to CONST05;
    signal cnt2: integer range 0 to CONST2;
    signal cntled: integer range 0 to led;
	 signal stop: std_logic;
    
    type state_typ is (init, closed, opened, z1, z2, z3, z4, z5, z6, z7, z8,z9,
                          z10, z11, z12, z13, z14, z15, z16, z17, z18); 
    signal state: state_typ;
    
    begin
  decoder: process 
    begin
      ---------------------------------------------------Led Muster---------------------------------------
      wait until rising_edge(clk);
        case cntled is
          when 0 => dioden <= "100000000000000001";
          when 1 => dioden <= "110000000000000011";
          when 2 => dioden <= "111000000000000111";
          when 3 => dioden <= "111100000000001111";
          when 4 => dioden <= "111110000000011111";
          when 5 => dioden <= "111111000000111111";
          when 6 => dioden <= "111111100001111111";
          when 7 => dioden <= "111111110011111111";
          when 8 => dioden <= "111111111111111111";
          when others => dioden <= "100000000000000001";
          end case;
      end process;
      --------------------------------------------------- End Led Muster-------------------------------------
  
  fsm: process begin
    wait until rising_edge(clk);
	 if rst = '1' then
	 state <= init;
	 end if;
    case state is
      when init =>
        int_s0 <=18; int_s1 <=18; int_s2 <= 18; int_s3 <=18;      --aus
        cnt05 <= CONST05;
        cnt2 <= CONST2;
        cntled <= 0;
		  stop <= '0';
		  int_taste<=taste;
        if dreher /= "00" then
          state <=z1;
        end if;
      --------------------------------------------------- Z1 ---------------------------------------------------
    when z1 =>
      int_s0 <= 11; int_s1 <= 14; int_s2 <= 10; int_s3 <=0;  --- Anzeige Open
      if cnt05 = 0 then -- wird nach 0,5s geöffnet
        state <= z2;
        int_s0<=0; int_s1<=18; int_s2 <=18; int_s3 <= 18; -- Anzeige 1
      else
        cnt05 <= cnt05 -1;                                -- Timer dec 0,5s 
      end if;
      ----------------------------------------------------------------------------------------------------------
      --------------------------------------------------- Z2 ---------------------------------------------------
    when z2 => 
    if cnt2 = 0 then                                      -- ohne Eingabe 2 Sec
      state <= init;                                      -- zurück 
    else                                                  -- dec 2 sec 
      cnt2 <=cnt2 -1;
    end if;
    if dreher = "10" then                    
      cnt2 <= CONST2;
      int_s0 <= int_s0 +1;
    if int_s0 = 9 then 
      int_s0 <= 0;
    end if;
    elsif dreher = "01" then
      cnt2 <= CONST2;                                      --Timer 2sec init
      int_s0 <= int_s0 -1;                                  
      if int_s0 = 0 then 
        int_s0<=9;
      end if;
    end if;
    if taste = '1' then 
      int_s1 <=0;
		stop<= '0';
      cnt2<= CONST2;
      state <= z3;
    end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z3 ---------------------------------------------------
  when z3 =>
  int_taste<= '0';
  if cnt2 = 0 then 
    state <= init;
  else 
    cnt2 <=cnt2 -1;stop <='1';
  end if;
  if dreher = "10" then 
    cnt2 <= CONST2;
    int_s1 <= int_s1 +1;
    if int_s1 = 9 then 
      int_s1 <= 0;
    end if;
  elsif dreher = "01" then 
    cnt2<=CONST2;
    int_s1 <= int_s1 -1;
    if int_s1 = 0 then
      int_s1 <= 9;
    end if;
  end if;
  if taste = '1' then 
    int_s2 <= 0;
    cnt2 <=CONST2;
    state <= z4;
  end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z4 ---------------------------------------------------
  when z4 =>
  --taste<= '0';
  if cnt2 = 0 then 
    state <= init;
  else 
    cnt2 <=cnt2 -1;
  end if;
  if dreher = "10" then 
    cnt2 <= CONST2;
    int_s2 <= int_s2 +1;
    if int_s2 = 9 then 
      int_s2 <= 0;
    end if;
  elsif dreher = "01" then 
    cnt2<=CONST2;
    int_s2 <= int_s2 -1;
    if int_s2 = 0 then
      int_s2 <= 9;
    end if;
  end if;
  if taste = '1' then 
    int_s3 <= 0;
    cnt2 <=CONST2;
    state <= z5;
  end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z5 ---------------------------------------------------
   when z5 =>
  --taste<= '0';
  if cnt2 = 0 then 
    state <= init;
  else 
    cnt2 <=cnt2 -1;
  end if;
  if dreher = "10" then 
    cnt2 <= CONST2;
    int_s3 <= int_s3 +1;
    if int_s3 = 9 then 
      int_s3 <= 0;
    end if;
  elsif dreher = "01" then 
    cnt2<=CONST2;
    int_s3 <= int_s3 -1;
    if int_s3 = 0 then
      int_s3 <= 9;
    end if;
  end if;
  if taste = '1' then 
    cnt2 <=CONST2;
	  c0<=int_s0; c1<=int_s1; c2 <=int_s2; c3 <= int_s3;
    state <= z6;
  end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z6 ---------------------------------------------------
  when z6 =>
    if cnt2 = 0 then
	 int_s0 <= 13; int_s1 <= 5; int_s2 <= 16; int_s3 <=12;---- clsd

	 cnt2 <=CONST2;
	 cnttkt <= CONST01;
    state <= closed;
    else
      cnt2 <= cnt2 -1;
    end if;
    -----------------------------------------------------------------------------------------------------------
    ------------------------------------------------ Closed ---------------------------------------------------
  when closed =>
		if cnttkt = 0 and cntled /=9 then
				cntled <=cntled+1;
			cnttkt <= CONST01;	
		else
				cnttkt <= cnttkt -1;

		end if;
		if cntled = 9 then
		int_s0 <= 18; int_s1 <= 18; int_s2 <= 18; int_s3 <=18;
		end if;
		
	    if dreher = "01" or dreher = "10" then 
		   cnt05 <= CONST05;
			state<=z7;
      end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z7 ---------------------------------------------------
  when z7 =>
      int_s0 <= 13; int_s1 <= 5; int_s2 <= 16; int_s3 <=12;---- clsd
      if cnt05 = 0 then
			cnt2 <= const2;
        state <= z8;
        int_s0<=0; int_s1<=18; int_s2 <=18; int_s3 <= 18;
      else
        cnt05 <= cnt05 -1;
      end if;
      
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z8 ---------------------------------------------------
  when z8 =>
    if cnt2 = 0 then 
      state <= closed;
    else 
      cnt2 <=cnt2 -1;
    end if;
    if dreher = "10" then 
      cnt2 <= CONST2;
      int_s0 <= int_s0 +1;
    if int_s0 = 9 then 
      int_s0 <= 0;
    end if;
    elsif dreher= "01" then
      cnt2 <= CONST2;
      int_s0 <= int_s0 -1;
      if int_s0 = 0 then 
        int_s0<=9;
      end if;
    end if;
    if taste = '1' then 
      int_s1 <=0;
      cnt2<= CONST2;
      state <= z9;
    end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z9 ---------------------------------------------------
  when z9 =>
  --taste<= '0';
  if cnt2 = 0 then 
    state <= closed;
  else 
    cnt2 <=cnt2 -1;
  end if;
  if dreher = "10" then 
    cnt2 <= CONST2;
    int_s1 <= int_s1 +1;
    if int_s1 = 9 then 
      int_s1 <= 0;
    end if;
  elsif dreher = "01" then 
    cnt2<=CONST2;
    int_s1 <= int_s1 -1;
    if int_s1 = 0 then
      int_s1 <= 9;
    end if;
  end if;
  if taste = '1' then 
    int_s2 <= 0;
    cnt2 <=CONST2;
    state <= z10;
  end if;
    -----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z10 ---------------------------------------------------
  when z10 =>
  if cnt2 = 0 then 
    state <= closed;
  else 
    cnt2 <=cnt2 -1;
  end if;
  if dreher = "10" then 
    cnt2 <= CONST2;
    int_s2 <= int_s2 +1;
    if int_s2 = 9 then 
      int_s2 <= 0;
    end if;
  elsif dreher = "01" then 
    cnt2<=CONST2;
    int_s2 <= int_s2 -1;
    if int_s2 = 0 then
      int_s2 <= 9;
    end if;
  end if;
  if taste = '1' then 
    int_s3 <=0;
    cnt2 <=CONST2;
    state <= z11;
  end if;
    -----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z11 ---------------------------------------------------
  when z11 =>
  --taste<= '0';
  if cnt2 = 0 then 
    state <= closed;
  else 
    cnt2 <=cnt2 -1;
  end if;
  if dreher = "10" then 
    cnt2 <= CONST2;
    int_s3 <= int_s3 +1;
    if int_s3 = 9 then 
      int_s3 <= 0;
    end if;
  elsif dreher = "01" then 
    cnt2<=CONST2;
    int_s3 <= int_s3 -1;
    if int_s3 = 0 then
      int_s3 <= 9;
    end if;
  end if;
  if taste = '1' then 
    cnt2 <=CONST2;
    state <= z12;
  end if;
    ------------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z12 ----------------------------------------------------
  when z12 =>
    if (c0 = int_s0) and (c1 = int_s1) and (c2 = int_s2) and (c3 = int_s3) then
      int_s0 <= 11; int_s1 <= 14; int_s2 <= 10; int_s3 <=0;
		cnt05 <= CONST05;
      state <= opened;
    else 
      int_s0 <= 18; int_s1 <= 15; int_s2 <= 15; int_s3 <= 14;
      cnttkt <= CONST01;
      state <=z13;
    end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Open -------------------------------------------------
  when opened =>
      if cnttkt = 0 and cntled /=0 then
				cntled <=cntled-1;
			   cnttkt <= CONST01;	
		else
				cnttkt <= cnttkt -1;

		end if;
		if cntled = 0 then
      state <= init;
    end if;
    -----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z13 ---------------------------------------------------
  when z13 => 
    if cnt05 =0 then
      cnt05<=CONST05;
      int_s0 <= 18; int_s1 <= 18; int_s2 <=18; int_s3 <= 18;
      state <= z14;
    else
      cnt05 <= cnt05 -1;
    end if;
    -----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z14 ---------------------------------------------------
  when z14 =>
    if cnt05 =0 then
      cnt05<=CONST05;
      int_s0 <= 18; int_s1 <= 15; int_s2 <= 15; int_s3 <= 14;
      state <= z15;
    else
      cnt05 <= cnt05 -1;
    end if;
    -----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z15 ---------------------------------------------------
  when z15 =>
    if cnt05 =0 then
      cnt05<=CONST05;
      int_s0 <= 18; int_s1 <= 18; int_s2 <=18; int_s3 <= 18;
      state <= z16;
    else
      cnt05 <= cnt05 -1;
    end if;
    -----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z16 ---------------------------------------------------
  when z16 =>
    if cnt05 =0 then
      cnt05<=CONST05;
      int_s0 <= 18; int_s1 <= 15; int_s2 <= 15; int_s3 <= 14;
      state <= z17;
    else
      cnt05 <= cnt05 -1;
    end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z17 ---------------------------------------------------
  when z17 =>
     if cnt05 =0 then
      cnt05<=CONST05;
      int_s0 <= 18; int_s1 <= 18; int_s2 <=18; int_s3 <= 18;
      state <= z18;
    else
      cnt05 <= cnt05 -1;
    end if;
    -----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- Z18 ---------------------------------------------------
  when z18 =>
    if cnt05 =0 then
      cnt05<=CONST05;
      int_s0 <= 18; int_s1 <= 15; int_s2 <= 15; int_s3 <= 14;
      state <= closed;
    else
      cnt05 <= cnt05 -1;
    end if;
    ----------------------------------------------------------------------------------------------------------
    --------------------------------------------------- End Z ------------------------------------------------
    
    
  end case;
  end process;
	s0<=(std_logic_vector(to_unsigned(int_s0,5)));
   s1<=(std_logic_vector(to_unsigned(int_s1,5)));
	s2<=(std_logic_vector(to_unsigned(int_s2,5)));
	s3<=(std_logic_vector(to_unsigned(int_s3,5)));
  end arch;