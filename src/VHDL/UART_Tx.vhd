----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Nick Diocson
-- 
-- Create Date: 10/19/2019 11:55:14 AM
-- Design Name: UART Transmitter
-- Module Name: UART_Tx - Behavioral
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

entity UART_Tx is
    Generic (
            BAUD_RATE       : integer := 9600;
            BIT_CNT         : integer := 1040;
            SAMPLE_CNT      : integer := 520;
            TRAN_BITS       : integer := 8
            );
    Port (
            clk, reset      : in std_logic;
            tx_bits         : in std_logic_vector(TRAN_BITS - 1 downto 0);
            output_stream   : out std_logic
            );
end entity UART_Tx;

architecture Behavioral of UART_Tx is

-- Counter Component Declaration
component Counter is
    Generic (
            CLK_FREQ        : positive := 1E7;      -- on-board clock frequency (10 MHz)
            MAX_COUNT       : positive := 520       -- maximum number of cycles to count to
            );
    Port ( 
            clk, reset      : in std_logic;
            max_reached     : out std_logic
            );
end component Counter;

-- FIFO Component Declaration
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

-- CLK_FREQ:        Constant frequency of on-board clock (10 MHz for Arty A7-35T)
-- reset_count:     Internal signal used to reset counter instantiations
constant CLK_FREQ   : positive := 1E7;
signal reset_count  : std_logic := '1';

-- full_bit:        Internal signal used to indicate when a new bit is to be read from the input_stream
-- sample_bit:      Internal signal used to indicate when the current bit is to be sampled from the input_stream
-- in_bit:          Internal signal used to buffer tx_bits
-- out_bit:         Internal signal used to drive the output_stream
signal full_bit     : std_logic := '0';
signal sample_bit   : std_logic := '0';
signal in_bit       : std_logic := '0';
signal out_bit      : std_logic := '1';

begin

    -- Instantiates a Counter to drive the full_bit signal
    bit_count: entity work.Counter(Behavioral)
        Generic Map (CLK_FREQ => CLK_FREQ, MAX_COUNT => BIT_CNT + 1)
        Port Map (clk => clk, reset => reset_count, max_reached => full_bit);
    
    -- Instantiates a Counter to drive the sample_bit signal
    sample_count: entity work.Counter(Behavioral)
        Generic Map (CLK_FREQ => CLK_FREQ, MAX_COUNT => SAMPLE_CNT)
        Port Map (clk => clk, reset => reset_count, max_reached => sample_bit);
        
    -- Instantiates a FIFO buffer to drive the out_bit signal
    fifo_buf: entity work.FIFO(Behavioral)
        Generic Map (SIZE => TRAN_BITS)
        Port Map (reset => reset, in_bit => in_bit, out_bit => out_bit);
    
    read_out: process(tx_bits) is
    begin
        
    end process read_out;

end architecture Behavioral;
