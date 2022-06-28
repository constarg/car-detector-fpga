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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity car_leaves is
    Port ( 
            sensors: in std_logic_vector(1 downto 0);
            clk: in std_logic;
            leave: out std_logic
         );
end car_leaves;

architecture Behavioral of car_leaves is

    -- FSM - State machine.
    type car_fms is (s0, s1, s2, s3, s4);

    -- port a states.
    signal port_current_s: car_fms := s0;
    signal port_next_s: car_fms := s0;
   
    signal leave_s: std_logic := '0';

begin
    leave <= leave_s;

    -- process for port a.
    car_set_state: 
    process (clk)
    begin
        if rising_edge(clk)
        then
            port_current_s <= port_next_s;
        end if;
        
    end process car_set_state;
    
    -- change state
    car_change_a_state:
    process (port_current_s, sensors) is
    begin
        port_next_s <= port_current_s;
        -- change the state of port a.
        case port_current_s is
            when s0 =>
                -- car reach the first sensor.
                if sensors = "10"
                then
                    port_next_s <= s1;
                else
                    port_next_s <= s0;
                end if;
            when s1 =>
                -- car reach the two sensors.
                if sensors = "11"
                then
                    port_next_s <= s2;
                elsif sensors = "00"
                then
                    port_next_s <= s0;
                else
                    port_next_s <= s1;
                end if;
            when s2 =>
                -- car leave from first sensor.
                if sensors = "01"
                then
                    port_next_s <= s3;
                elsif sensors = "00"
                then
                    port_next_s <= s0;
                else
                    port_next_s <= s2;
                end if;
            when s3 =>
                -- car leave the second sensor.
                if sensors = "00"
                then
                    port_next_s <= s4;
                elsif sensors = "11"
                then
                    port_next_s <= s2;
                else
                    port_next_s <= s3;
                end if;
            when s4 =>
                port_next_s <= s0;
        end case;
    
    end process car_change_a_state;
    
    -- car enters.
    car_enter: 
    process (port_current_s) is
    begin
         case port_current_s is
            when s4 =>
                leave_s <= '1';
            when others =>
                leave_s <= '0';
                
         end case;
         
    end process car_enter;


end Behavioral;
