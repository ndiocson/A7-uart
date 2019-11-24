----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Nick Diocson
-- 
-- Create Date: 10/31/2019 07:19:03 AM
-- Design Name: UART Testbench
-- Module Name: UART_Tb - Test
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

entity UART_Tb is
end entity UART_Tb;

architecture Test of UART_Tb is

component UART is
    Generic (
            BAUD_RATE       : positive := 9600;
            BIT_CNT         : positive := 651;
            SAMPLE_CNT      : positive := 325;
            TRAN_BITS       : positive := 8
            );
    Port (
            clk, reset      : in std_logic;
            transmit        : in std_logic;
            tx_data         : in std_logic_vector(TRAN_BITS - 1 downto 0);
            rx_data         : out std_logic_vector(TRAN_BITS - 1 downto 0);
            Rx              : in std_logic;
            Tx              : out std_logic 
            );
end component UART;

-- CLK_PERIOD:          Simulated Clock Period
-- BAUD_RATE:           9600 bits per second
-- BIT_CNT:             Number of clock cycles to represent a bit
-- SAMPLE_CNT           Number of clock cycles to sample a bit
-- TRAN_BITS:           Number of transmission bits
constant CLK_PERIOD     : time := 10 ns;
constant BAUD_RATE      : positive := 9600;
constant BIT_CNT        : positive := 651;
constant SAMPLE_CNT     : positive := 325;
constant TRAN_BITS      : positive := 32;

-- data_stream:         Signal to be transmitted to and received from by both DUTs
--signal data_stream      : std_logic;
signal stream_1         : std_logic;
signal stream_2         : std_logic;

-- Input Signals
signal clk              : std_logic := '0';
signal reset_1          : std_logic := '0';
signal reset_2          : std_logic := '0';
signal transmit_1       : std_logic := '0';
signal transmit_2       : std_logic := '0';
signal tx_data_1        : std_logic_vector(TRAN_BITS - 1 downto 0);
signal tx_data_2        : std_logic_vector(TRAN_BITS - 1 downto 0);

-- Output Signal
signal rx_data_1        : std_logic_vector(TRAN_BITS - 1 downto 0);
signal rx_data_2        : std_logic_vector(TRAN_BITS - 1 downto 0);


begin
    
    -- Instantiates first UART device under test
    DUT_1: UART
        Generic Map(BAUD_RATE => BAUD_RATE, BIT_CNT => BIT_CNT, SAMPLE_CNT => SAMPLE_CNT, TRAN_BITS => TRAN_BITS)
        Port Map (clk => clk, reset => reset_1, transmit => transmit_1, tx_data => tx_data_1, rx_data => rx_data_1, Rx => stream_1, Tx => stream_2);
        
    -- Instantiates second UART device under test
    DUT_2: UART
        Generic Map(BAUD_RATE => BAUD_RATE, BIT_CNT => BIT_CNT, SAMPLE_CNT => SAMPLE_CNT, TRAN_BITS => TRAN_BITS)
        Port Map (clk => clk, reset => reset_2, transmit => transmit_2, tx_data => tx_data_2, rx_data => rx_data_2, Rx => stream_2, Tx => stream_1);

    -- Drives input clk signal
    drive_clk: process is
    begin
        clk <= '1';
        wait for CLK_PERIOD / 2;
        clk <= '0';
        wait for CLK_PERIOD / 2;
    end process drive_clk;
    
    -- Process to stimulate reset signal
--    reset_stim: process is
--    begin
--        wait for 8 ms;
--        reset_1 <= '1';
--        reset_2 <= '1';
--        wait for 5 us;
--        reset_1 <= '0';
--        reset_2 <= '0';
--        wait;
--    end process reset_stim;
    
    -- Process to stimulate first data stream
    stimulus_1: process is
    begin
        wait for 100 us;
        tx_data_1 <= "01010101010101010101010101010101";
        wait for 200 us;
        transmit_1 <= '1';
        wait for 5 us;
        transmit_1 <= '0';
        
        wait for 500 us;
        tx_data_1 <= "00000000000000000000000000000000";
        wait for 200 us;
        transmit_1 <= '1';
        wait for 5 us;
        transmit_1 <= '0';
        
        wait for 300 us;
        tx_data_1 <= "10101010101010101010101010101010";
        wait for 100 us;
        transmit_1 <= '1';
        wait for 5 us;
        transmit_1 <= '0';
        wait;
    end process stimulus_1;

    -- Process to stimulate second data stream
    stimulus_2: process is
    begin
        wait for 300 us;
        tx_data_2 <= "10101010101010101010101010101010";
        wait for 100 us;
        transmit_2 <= '1';
        wait for 5 us;
        transmit_2 <= '0';
        
        wait for 300 us;
        tx_data_2 <= "11111111111111111111111111111111";
        wait for 100 us;
        transmit_2 <= '1';
        wait for 5 us;
        transmit_2 <= '0';
        
        wait for 500 us;
        tx_data_2 <= "01010101010101010101010101010101";
        wait for 200 us;
        transmit_2 <= '1';
        wait for 5 us;
        transmit_2 <= '0';
        wait;
    end process stimulus_2;     

end architecture Test;