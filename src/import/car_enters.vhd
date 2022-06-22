----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2022 04:04:52 PM
-- Design Name: 
-- Module Name: car_enters - Behavioral
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

entity car_enters is
    Port ( 
            sensors: in std_logic_vector(1 downto 0);
            clk: in std_logic;
            entered: out std_logic
         );
end car_enters;

architecture Behavioral of car_enters is

    -- FSM - State machine.
    type car_fms is (s0, s1, s2, s3, s4);
    
    -- port a states.
    signal port_a_current: car_fms := s0;
    signal port_a_next: car_fms := s0;
       
    signal entered_s: std_logic := '0';
begin

    entered <= entered_s;

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
    process (port_a_current, sensors) is
    begin
        port_a_next <= port_a_current;
        -- change the state of port a.
        case port_a_current is
            when s0 =>
               
                -- car reach the first sensor.
                if sensors = "01"
                then
                    port_a_next <= s1;
                else
                    port_a_next <= s0;
                end if;
            when s1 =>
                -- car reach the two sensors.
                if sensors = "11"
                then
                    port_a_next <= s2;
                else
                    port_a_next <= s0;
                end if;
            when s2 =>
                -- car leave from first sensor.
                if sensors = "10"
                then
                    port_a_next <= s3;
                else
                    port_a_next <= s0;
                end if;
            when s3 =>
                -- car leave the second sensor.
                if sensors = "00"
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
                entered_s <= '1';
            when others =>
                entered_s <= '0';
                
         end case;
         
    end process car_enter;

end Behavioral;
