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
    
    -- FSM - State machine.
    type car_fms is (s0, s1, s2, s3, s4);
    
    -- port a states.
    signal port_a_current: car_fms := s0;
    signal port_a_next: car_fms := s0;
    -- port b states.
    signal port_b_current: car_fms := s0;
    signal port_b_next: car_fms := s0;
    
    -- free space.
    signal park_free_s: std_logic_vector(3 downto 0) := "1111";
    -- total cars.
    signal park_total: unsigned(3 downto 0) := "0000";


begin
    a <= din(1 downto 0);
    b <= din(3 downto 2);
    
    -- process for port a.
car_set_state: 
        process (clk)
        begin
            if rising_edge(clk)
            then
                port_a_current <= port_a_next;
            end if;
            
        end process car_set_state;
        
-- change state
car_change_a_state:
        process (port_a_current, a) is
        begin
            port_a_next <= port_a_current;
            -- change the state of port a.
            case port_a_current is
                when s0 =>
                    -- car reach the first sensor.
                    if a = "01"
                    then
                        port_a_next <= s1;
                    else
                        port_a_next <= s0;
                    end if;
                when s1 =>
                    -- car reach the two sensors.
                    if a = "11"
                    then
                        port_a_next <= s2;
                    else
                        port_a_next <= s0;
                    end if;
                when s2 =>
                    -- car leave from first sensor.
                    if a = "10"
                    then
                        port_a_next <= s3;
                    else
                        port_a_next <= s0;
                    end if;
                when s3 =>
                    -- car leave the second sensor.
                    if a = "00"
                    then
                        port_a_next <= s4;
                    else
                        port_a_next <= s0;
                    end if;
                when s4 =>
                    port_a_next <= s0;
            
            end case;
        
        end process car_change_a_state;
        
-- car enters.
car_enter: 
        process (port_a_current) is
        begin
             case port_a_current is
                when s4 =>
                    if std_logic_vector(park_total) < park_free_s
                    then
                        park_total <= park_total + 1;
                    else
                        park_total <= park_total;
                    end if;
                when others =>
                    park_total <= park_total;
                    
             end case;
             
        end process car_enter;
    
    -- initialize the parking space.
    park_free_s <= din when we = '1' else park_free_s;
    park_free <= park_free_s;

end Behavioral;
