----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2022 04:07:14 PM
-- Design Name: 
-- Module Name: car_leaves - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity car_leaves is
    Port ( 
            sensors: in std_logic_vector(1 downto 0);
            max: in std_logic_vector(3 downto 0);
            clk: in std_logic;
            entered: out std_logic
         );
end car_leaves;

architecture Behavioral of car_leaves is

begin


end Behavioral;
