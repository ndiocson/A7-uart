----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Nick Diocson
-- 
-- Create Date: 10/13/2019 01:25:27 PM
-- Design Name: UART Receiver Testbench
-- Module Name: UART_Rx_Tb - Test
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
use IEEE.numeric_std.all;

entity UART_Rx_Tb is
end UART_Rx_Tb;

architecture Test of UART_Rx_Tb is

component UART_Rx is
    Generic (
            BAUD_RATE       : integer := 9600;
            BIT_FREQ_CNT    : integer := 1040;
            SAMPLE_FREQ_CNT : integer := 520;
            TRAN_BITS       : integer := 8
            );
    Port (
            reset           : in std_logic;
            input_stream    : in std_logic;
            rx_bits         : out std_logic_vector(TRAN_BITS - 1 downto 0)
            );
end component UART_Rx;

-- Simulatted Clock Period
constant CLK_PERIOD     : time := 100 ns;

-- Number of transmission bits
constant TRAN_BITS      : integer := 8;

-- Input Signals
signal clk              : std_logic := '0';
signal reset            : std_logic := '0';
signal input_stream     : std_logic := '1';

-- Output Signal
signal rx_bits          : std_logic_vector(TRAN_BITS - 1 downto 0);

begin

    -- Instantiates device under test
    DUT: entity work.UART_Rx(Behavioral)
        Generic Map(BAUD_RATE => open, BIT_FREQ_CNT => open, SAMPLE_FREQ_CNT => open, TRAN_BITS => TRAN_BITS)
        Port Map (reset => reset, input_stream => input_stream, rx_bits => rx_bits);

    -- Drives input clk signal
    drive_clk: process is
    begin
        clk <= '1';
        wait for CLK_PERIOD / 2;
        clk <= '0';
        wait for CLK_PERIOD / 2;
    end process drive_clk;

    -- Process to stimulate input signals of DUT
    stimulus: process is
    begin
        
        wait;
    end process stimulus;

end Test;
