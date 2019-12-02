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

entity UART_Rx_Tb is
end entity UART_Rx_Tb;

architecture Test of UART_Rx_Tb is

component UART_Rx is
    Generic (
            CLK_FREQ        : positive := 1E8;      -- on-board clock frequency (default: 100 MHz)
            BAUD_RATE       : positive := 9600;     -- rate of transmission (default: 9600 baud)
            TRAN_BITS       : positive := 8         -- number of transmission bits (defualt: 8)
            );
    Port (
            clk, reset      : in std_logic;
            input_stream    : in std_logic;
            rx_data         : out std_logic_vector(TRAN_BITS - 1 downto 0)
            );
end component UART_Rx;

-- CLK_PERIOD:          Simulated Clock Period
-- CLK_FREQ:            Clock frequency
-- BAUD_RATE:           9600 bits per second
-- TRAN_BITS:           Number of transmission bits
constant CLK_PERIOD     : time := 10 ns;
constant CLK_FREQ       : positive := 1E8;
constant BAUD_RATE      : positive := 9600;
constant TRAN_BITS      : positive := 32;

-- Input Signals
signal clk              : std_logic := '0';
signal reset            : std_logic := '0';
signal input_stream     : std_logic := '1';

-- Output Signal
signal rx_data          : std_logic_vector(TRAN_BITS - 1 downto 0);

begin

    -- Instantiates device under test
    DUT: UART_Rx
        Generic Map(CLK_FREQ => CLK_FREQ, BAUD_RATE => BAUD_RATE, TRAN_BITS => TRAN_BITS)
        Port Map (clk => clk, reset => reset, input_stream => input_stream, rx_data => rx_data);

    -- Drives input clk signal
    drive_clk: process is
    begin
        clk <= '1';
        wait for CLK_PERIOD / 2;
        clk <= '0';
        wait for CLK_PERIOD / 2;
    end process drive_clk;
    
    -- Process to stimulate reset signal
    reset_stim: process is
    begin
        wait for 2500 us;
        reset <= '1';
        wait for 5 us;
        reset <= '0';
        wait;
    end process reset_stim;

    -- Process to stimulate input signals of DUT
    stimulus: process is
    begin

        -- Functionality Test
        wait for 300 us;
        input_stream <= '0';
        wait for 208 us;
        input_stream <= '1';
        wait for 312 us;
        input_stream <= '0';
        wait for 208 us;
        input_stream <= '1';
        wait for 104 us;
        input_stream <= '0';
        wait for 104 us;
        input_stream <= '1'; 
        wait for 300 us;

        -- Invalid Input Stream Test
        wait for 300 us;
        input_stream <= '0';
        wait for 208 us;
        input_stream <= '1';
        wait for 312 us;
        input_stream <= '0';
        wait for 208 us;
        input_stream <= '1';
        wait for 104 us;
        input_stream <= '0';
        wait for 208 us;
        
        input_stream <= '1';
        wait for 300 us;
        input_stream <= '0';
        wait for 208 us;
        input_stream <= '1';
        wait for 312 us;
        input_stream <= '0';
        wait for 208 us;
        input_stream <= '1';
        wait for 104 us;
        input_stream <= '0';
        wait for 104 us;        
        input_stream <= '1';
        wait for 300 us;
    end process stimulus;

end architecture Test;