----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Nick Diocson
-- 
-- Create Date: 10/28/2019 10:21:10 PM
-- Design Name: FIFO Testbench
-- Module Name: FIFO_Tb - Test
-- Project Name: UART
-- Target Devices: Arty A7-35T
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
use IEEE.std_logic_1164.all;

entity FIFO_Tb is
end entity FIFO_Tb;

architecture Test of FIFO_Tb is

component FIFO is
    Generic (
            SIZE    : integer := 8 
            );
    Port ( 
            reset   : in std_logic;
            in_bit  : in std_logic;
            out_bit : out std_logic
            );
end component FIFO;

-- Input signals
signal reset    : std_logic := '0';
signal in_bit   : std_logic := '0';

-- Output signal
signal out_bit  : std_logic := '0';

begin

    -- Instatiates device under test
    DUT: FIFO
        Generic Map (SIZE => open)
        Port Map (reset => reset, in_bit => in_bit,out_bit => out_bit);

    stimulus: process is
    begin
        wait for 10 ns;
        in_bit <= '1';
        wait for 10 ns;
        in_bit <= '0';
        wait for 20 ns;
        in_bit <= '1';
        wait for 30 ns;
        in_bit <= '0';
    end process stimulus;

end architecture Test;
