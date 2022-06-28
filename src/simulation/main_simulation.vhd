----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2022 03:12:55 PM
-- Design Name: 
-- Module Name: main_simulation - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_simulation is
--  Port ( );
end main_simulation;

architecture Behavioral of main_simulation is

      signal ce_s: std_logic := '0';
      signal clk_s: std_logic := '0';
      signal we_s: std_logic := '0';
      signal din_s: std_logic_vector(3 downto 0) := (others => '0');
      signal full_s: std_logic := '0';
      signal empty_s: std_logic := '0';
      signal park_free_s: std_logic_vector(3 downto 0) := (others => '0');
      
begin
      
main_e:
      entity work.main(Behavioral)
      port map(
                 ce => ce_s,
                 clk => clk_s,
                 we => we_s,
                 din => din_s,
                 full => full_s,
                 empty => empty_s,
                 park_free => park_free_s
              );
      
clock_p:
     process is
     begin
          clk_s <= '1';
          wait for 5ns;
          clk_s <= '0';
          wait for 5ns;
     end process clock_p;
      
control_signals:
    process is
    begin
         ce_s <= '1';
         wait for 30ns;
         ce_s <= '0';
         wait for 30ns;
         we_s <= '0';
         wait for 30ns;
         we_s <= '1';
         wait for 30ns;
    end process control_signals;     
 
din_signal:
    process is
    begin
        -- enter from a.
        for i in 0 to 2**4-1
        loop
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             din_s <= "0001";
             wait for 10ns;
             din_s <= "0011";
             wait for 10ns;
             din_s <= "0010";
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             -- check if we put more cars.
             assert full_s = '0' and i < 15 report "FULL PARKING" severity warning;
             
         end loop;
    
         -- exit from a.         
         for i in 0 to 2**4-1
         loop
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             din_s <= "0010";
             wait for 10ns;
             din_s <= "0011";
             wait for 10ns;
             din_s <= "0001";
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             -- check if car leaves from empty parking.
             assert empty_s = '0' and i < 15 report "EMPTY PARKING" severity warning;
             
         end loop;
         
         -- enter from b.
         for i in 0 to 2**4-1 
         loop
              wait for 10ns;
              din_s <= "0000";
              wait for 10ns;
              din_s <= "0100";
              wait for 10ns;
              din_s <= "1100";
              wait for 10ns;
              din_s <= "1000";
              wait for 10ns;
              din_s <= "0000";
              wait for 10ns;
              assert full_s = '0' and i < 15 report "FULL PARKING" severity warning;
         end loop;

         -- exit from b.
         for i in 0 to 2**4-1
         loop
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             din_s <= "1000";
             wait for 10ns;
             din_s <= "1100";
             wait for 10ns;
             din_s <= "0100";
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             assert empty_s = '0' and i < 15 report "EMPTY PARKING" severity warning;             
         end loop;


         -- enter from a and b.
         for i in 0 to 2**4-1
         loop
              wait for 10ns;
              din_s <= "0000";
              wait for 10ns;
              din_s <= "0101";
              wait for 10ns;
              din_s <= "1111";
              wait for 10ns;
              din_s <= "1010";
              wait for 10ns;
              din_s <= "0000";
              wait for 10ns;
              assert full_s = '0' and i < 15 report "FULL PARKING" severity warning;
         end loop;
        
         -- exit from a and b.
         for i in 0 to 2**4-1 
         loop
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             din_s <= "1010";
             wait for 10ns;
             din_s <= "1111";
             wait for 10ns;
             din_s <= "0101";
             wait for 10ns;
             din_s <= "0000";
             wait for 10ns;
             assert empty_s = '0' and i < 15 report "EMPTY PARKING" severity warning;
         end loop;

         wait; 
    end process din_signal;      



end Behavioral;
