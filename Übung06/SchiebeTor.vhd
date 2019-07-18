library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SchiebeTor is
  port (
    clk, rst, fb, KR, KL, LS: in std_logic; 
    ML, MR, ledKR, ledKL, enable: out std_logic;   
    ledR, ledL , ledg8 : out std_logic;
    zustand: out std_logic_vector(3 downto 0));
  end entity;
  
  architecture arch of SchiebeTor is
    
    signal prevState: std_logic;
    signal int_enable: std_logic;
	 constant CONST01: integer:=  10000000 - 1; --0.2 sekunde
    constant CONST1: integer:=  50000000 - 1; --0.5 sekunde
    constant CONST5: integer:=  250000000 -1;
    constant CONST38: integer:= 658 -1;
	 signal cnt01: integer range 0 to CONST01;
    signal cnt1: integer range 0 to CONST1;
    signal cnt5: integer range 0 to CONST5;
    signal cnttkt: integer range 0 to CONST38;
    type state_typ is (init, z1, z2, z3, z4, z5, z6, z7, z8,z9, z10, z11); 
    signal state: state_typ;
    
    begin
    takt: process begin ----------------------------------------------takt teiler
      wait until rising_edge(clk);
      if cnttkt = CONST38 then
        cnttkt <=0;
        int_enable <= not int_enable;
      else
        cnttkt <= cnttkt +1;
      end if;
      enable <= int_enable;
    end process;-------------------------------------------------------------end takteiler
  
  ST: process begin
    wait until rising_edge(clk);
	 
    if LS = '0' then
      ledg8 <= '1';
    else ledg8 <= '0';
    end if;
    case state is
      when init =>------------------------------------------------------------------init
          ledKR <= '0';
          ledKL <= '0';
			 ledL <= '0';
			 ledR <= '0';
			 ML <= '0';
			 MR <= '0';
          cnt5 <= CONST5;
          cnt1 <= CONST1;
			 cnt01<=CONST01;
          zustand <= "0000"; 
		  if FB = '1' then
          state <= z1;
        end if;
      when z1 =>--------------------------------------------------------------------z1
			ledKL <= '0';
          zustand <= "0001";
          if KR = '0' then 
				 MR <= '1';
			    ledR <= '1';
          else 
            state <= z2;
          end if;
          if FB = '1' then
            MR <= '0';
           state <= z9;
          end if; -----------------------------------------------------------------------
      when z2 =>---------------------------------------------------------------------z2 
         ledR <= '0';
         zustand <= "0010";
         MR <= '0';
         ledKR <= '1';
			if cnt1 = 0 then 
          cnt1 <= CONST1;
			 state<= z3;
        else 
          cnt1 <= cnt1-1;
        end if;
        -----------------------------------------------------------------------------
      when z3 =>---------------------------------------------------------------------z3
        ledL <= '1';
        zustand <= "0011";
        if cnt01 = 0 then 
          ML <= '0';
			 cnt01 <= CONST01;
          state <= z4;
        else 
          cnt01 <= cnt01-1;
          ML <= '1';
        end if;------------------------------------------------------------------------ 
      when z4 =>---------------------------------------------------------------------z4
        ledL <= '0';
        zustand <= "0100";        
        if LS = '0' then 
          if cnt5 = 0 then 
            cnt5 <= CONST5;
            state <= z5;
          else
            cnt5 <= cnt5 -1;
          end if; 
          if FB = '1' then 
            state <= z5;
          end if;
        end if;
      -------------------------------------------------------------------------------
      when z5 =>---------------------------------------------------------------------z5
        ledL <= '1';
		  prevState <= '0';
        zustand <= "0101";
        ledKR <= '0';
		  if LS = '0' then 
       if KL = '0' then
         ML <= '1';
       else 
         state <= z6;
       end if;
		 if FB = '1' then
		 ML <= '0';
		 state <= z10;
		 end if;
		 else 
			
			state <= z11;
		end if;-----------------------------------------------------------------------
      when z6 =>---------------------------------------------------------------------z6
        ledL <= '0';
        zustand <= "0110";
        ML <= '0';
        ledKL <= '1';
		  if cnt1 = 0 then 
		  cnt1 <= CONST1;
          state<= z7;
        else 
          cnt1 <= cnt1-1;
        end if;
      -------------------------------------------------------------------------------
      when z7 =>---------------------------------------------------------------------z7
        ledR <= '1';
        zustand <= "0111";
        if cnt01 = 0 then 
          MR <= '0';
			 cnt01 <= CONST01;
          state <= z8;
        else 
          cnt01 <= cnt01-1;
          MR <= '1';
        end if;----------------------------------------------------------------------
      when z8 =>---------------------------------------------------------------------z8 
        ledR <= '0';
        zustand <= "1000";
        if FB = '1' then 
          state <= z1;
        end if;
      -------------------------------------------------------------------------------
      when z9 =>---------------------------------------------------------------------z9
        zustand <= "1001";
		  cnt1 <= CONST1;
        if cnt1 = 0 then
				ledR <= '0';
				cnt1 <= CONST1;
            state <= z5;
        else 
          cnt1 <= cnt1-1;
        end if;-----------------------------------------------------------------------
		when z10 =>---------------------------------------------------------------------z9
        zustand <= "1001";
		  cnt1 <= CONST1;
        if cnt1 = 0 then
			   ledL <= '0';
				cnt1 <= CONST1;
            state <= z1;
        else 
          cnt1 <= cnt1-1;
        end if;-----------------------------------------------------------------------
		  when z11 =>
		  ledL <= '0';
		  ML <= '0';
		  state <= z1;
  end case;
  if rst = '1' then
	    state <= init;
	 end if;
  end process;
  end arch;