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
    
    -- free space.
    signal park_free_s: std_logic_vector(3 downto 0) := "1111";
    -- max number of cars.
    signal park_max: std_logic_vector(3 downto 0) := "1111";
    -- total cars.
    signal park_total: std_logic_vector(3 downto 0) := "0000";

    -- if car enter on a.
    signal car_a_enters: std_logic_vector(0 downto 0);
    -- if car enter on b.
    signal car_b_enters: std_logic_vector(0 downto 0);
    -- if car leave on a.
    signal car_a_leaves: std_logic_vector(0 downto 0);
    -- if car leave on b.
    signal car_b_leaves: std_logic_vector(0 downto 0);

begin
    -- sensor for port a.
    a <= din(1 downto 0);
    -- sensor for port b.
    b <= din(3 downto 2);   

car_enter_a:
    entity work.car_enters(Behavioral)
    port map(
              sensors => a,
              clk => clk,
              entered => car_a_enters(0)
            );
            
car_enter_b:
     entity work.car_enters(Behavioral)
     port map(
              sensors => b,
              clk => clk,
              entered => car_b_enters(0)
             );  

car_leaves_a:
     entity work.car_leaves(Behavioral) 
     port map(
              sensors => a,
              clk => clk,
              leave => car_a_leaves(0)
             );  

car_leaves_b:
     entity work.car_leaves(Behavioral) 
     port map(
              sensors => b,
              clk => clk,
              leave => car_b_leaves(0)
             );  


-- add and remove the cars that enters and leaves
sum:
    process (clk) is
        variable park_tmp: std_logic_vector(4 downto 0) := "00000";
        variable park_sum: std_logic_vector(1 downto 0) := "00";
        variable park_def: std_logic_vector(1 downto 0) := "00";
        
    begin
        -- in the rising edge of the clock check.
        if rising_edge(clk)
        then
            -- the sum of the cars that has been entered.
            park_sum := '0' & std_logic_vector(unsigned(car_a_enters) + unsigned(car_b_enters));
            
            -- the sum of the cars that has been leave.
            park_def := '0' & std_logic_vector(unsigned(car_a_leaves) + unsigned(car_b_leaves));
            
            -- add to the total cars in the parking the new cars.
            park_tmp := std_logic_vector(unsigned(park_tmp) + unsigned(park_sum));
 
            -- if the cars in the park is greater than those who left.           
            if park_tmp > park_def
            then
                -- then remove the cars that left.
                park_total <= std_logic_vector(unsigned(park_tmp(3 downto 0)) - unsigned(park_def));
            else
                -- otherwise the cars in the parking is zero ( because the parking can't have negative car number ).
                park_total <= (others => '0');
            end if;
            
        end if;
        
    end process sum;
    
    
    -- initialize the parking space.
    
end Behavioral;
