----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2022 01:10:11 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
  Port (
            ce: in std_logic;
            clk: in std_logic;
            we: in std_logic;
            din: in std_logic_vector(3 downto 0);
            full: out std_logic;
            empty: out std_logic;
            park_free: out std_logic_vector(3 downto 0)
       );
end main;

architecture Behavioral of main is
    
    -- Sensors.
    signal a: std_logic_vector(1 downto 0);
    signal b: std_logic_vector(1 downto 0);
    
    -- max number of cars.
    signal park_total: std_logic_vector(3 downto 0) := "1111";
    -- total cars currently in parking.
    signal park_current: std_logic_vector(3 downto 0) := "0000";

    -- if car enter on a.
    signal car_a_enters: std_logic;
    -- if car enter on b.
    signal car_b_enters: std_logic;
    -- if car leave on a.
    signal car_a_leaves: std_logic;
    -- if car leave on b.
    signal car_b_leaves: std_logic;
    
    -- we bouncing.
    signal we_start_1: std_logic;
    signal we_start_2: std_logic;
    signal we_pulse: std_logic;

begin
    -- sensor for port a.
    a <= din(1 downto 0);
    -- sensor for port b.
    b <= din(3 downto 2);   

-- car enter port a.
car_enter_a:
    entity work.car_enters(Behavioral)
    port map(
              sensors => a,
              clk => clk,
              entered => car_a_enters
            );
            
-- car enter port b.
car_enter_b:
     entity work.car_enters(Behavioral)
     port map(
              sensors => b,
              clk => clk,
              entered => car_b_enters
             );  

-- car leaves from port a.
car_leaves_a:
     entity work.car_leaves(Behavioral) 
     port map(
              sensors => a,
              clk => clk,
              leave => car_a_leaves
             );  

-- car leaves from port b.
car_leaves_b:
     entity work.car_leaves(Behavioral) 
     port map(
              sensors => b,
              clk => clk,
              leave => car_b_leaves
             );  

-- add and remove the cars that enters and leaves
sum:
    process (clk) is
        variable park_tmp: unsigned(4 downto 0) := "00000";
                
    begin
        park_tmp := '0' & unsigned(park_current);
        -- in the rising edge of the clock check.
        if rising_edge(clk)
        then
            if ce = '0'
            then
                if car_a_enters = '1' then
                    park_tmp := park_tmp + 1;
                end if; 
                
                if car_b_enters = '1' then
                    park_tmp := park_tmp + 1;
                end if;
                
                if car_a_leaves = '1' then
                    park_tmp := park_tmp - 1;
                end if;
                
                if car_b_leaves = '1' then
                    park_tmp := park_tmp - 1;
                end if;
                
                -- if the parking has space for the new cars.
                if std_logic_vector(park_tmp) <= '0' & park_total
                then
                    park_current <= std_logic_vector(park_tmp(3 downto 0));
                else
                    -- otherwise the new cars didn't count.
                    park_tmp := '0' & unsigned(park_current);
                end if;
             end if;
            
        end if;
        
    end process sum;


-- Because the signal we is button, fix the problem of bouncing.
enable_we:
    process(clk) is
    begin
         if rising_edge(clk)
         then
             we_start_1 <= we;
             we_start_2 <= we_start_1;
         end if;
         
    end process enable_we;
    we_pulse <= we_start_1 and (not we_start_2);


-- the register that have the maximum free space.
register_park_total:
    process(clk) is
    begin
        if rising_edge(clk)
        then
            if we_pulse = '1' and (park_current = "0000")
            then
                park_total <= din;
            else
                park_total <= park_total;
            end if;
        end if;
    end process register_park_total;


    -- check if is empty of full.
    full <= '1' when park_current = park_total else '0';
    empty <= '1' when park_current = "0000" else '0';
   
    -- calulate free spaces.
    park_free <= std_logic_vector(unsigned(park_total) - unsigned(park_current));
   
end Behavioral;
