----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Nick Diocson
-- 
-- Create Date: 10/11/2019 11:12:20 PM
-- Design Name: UART Receiver
-- Module Name: UART_RX - Behavioral
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

entity UART_RX is
    Generic (
            BAUD_RATE       : integer := 9600;
            BIT_FREQ_CNT    : integer := 1040;
            SAMPLE_FREQ_CNT : integer := 520;
            N_BITS          : integer := 8
            );
    Port (
            reset           : in std_logic;
            input_stream    : in std_logic;
            rx_bits         : out std_logic_vector(N_BITS - 1 downto 0)
            );
end UART_RX;

architecture Behavioral of UART_RX is

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

-- CLK_FREQ:        Constant frequency of on-board clock (10 MHz for Arty A7-35T)
constant CLK_FREQ   : positive := 1E7;

-- clk:             Internal signal based on on-board clock used to drive counter
signal clk          : std_logic := '0';

-- state:           Enumerated type to define states of Receiver FSM
type state is (idle, init_read, read_bits, stop_read, done_read);

-- p_state:         Internal state signal used to represent the present state
-- n_state:         Internal state signal used to represent the next state
signal p_state, n_state : state := idle;

-- rx_init:         Internal signal used to indicate when to start recieving bits
-- rx_strt:         
-- rx_stop:         
-- rx_done:         
signal rx_init      : std_logic := '0';
signal rx_strt      : std_logic := '0';
signal rx_stop      : std_logic := '0';
signal rx_done      : std_logic := '0';

-- reset_count:     
-- full_bit:
-- sample_bit:      Internal signal used to indicate when to sample a bit from input_stream
-- out_bits:        
-- reset_UART       
signal reset_UART   : std_logic := '0';
signal reset_count  : std_logic := '0';
signal full_bit     : std_logic := '0';
signal sample_bit   : std_logic := '0';
signal out_bits     : std_logic_vector := (others => '0');

-- bit_pos:             
-- bit_pos_sig:                   
shared variable bit_pos : integer := 0;
signal bit_pos_sig      : integer := 0;

begin
    
    -- Instantiates a Counter to drive the full_bit signal
    bit_count: entity work.Counter(Behavioral)
        Generic Map (CLK_FREQ => CLK_FREQ, MAX_COUNT => BIT_FREQ_CNT)
        Port Map (clk => clk, reset => reset_count, max_reached => full_bit);
    
    -- Instantiates a Counter to drive the sample_bit signal
    sample_count: entity work.Counter(Behavioral)
        Generic Map (CLK_FREQ => CLK_FREQ, MAX_COUNT => SAMPLE_FREQ_CNT)
        Port Map (clk => clk, reset => reset_count, max_reached => sample_bit);
    
    -- Process that manages the present and next states
    state_machine: process(p_state, rx_init) is
    begin
        case p_state is
            when idle =>
                if (rx_init = '1') then
                    n_state <= init_read;
                else
                    n_state <= p_state;
                end if;
            when init_read =>
                if (rx_strt = '1') then
                    n_state <= read_bits;
                    bit_pos := 0;
                else
                    n_state <= p_state;
                end if;
            when read_bits =>
                if (rx_stop = '1') then
                    n_state <= stop_read;
                else
                    n_state <= p_state;
                end if;
            when stop_read =>
                if (rx_done = '1') then
                    n_state <= done_read;
                else
                    n_state <= p_state;                
                end if;
            when done_read =>
                rx_bits <= out_bits;
                n_state <= idle; 
        end case;
    end process state_machine;
    
    -- Process that handles the memory elements for the FSM
    memory_elem: process(clk, reset, reset_UART) is
    begin
        if (reset = '1' or reset_UART = '1') then
            p_state <= idle;
        elsif (rising_edge(clk)) then
            p_state <= n_state;
        end if;
    end process memory_elem;
    
    -- Monitors the input_stream and sets rx_init to '1' 
    -- when the transmission first goes to '0'
    monitor_init: process (sample_bit) is
    begin
        if (p_state = idle) then
            if (sample_bit = '1') then
                if (input_stream = '0') then
                    rx_init <= '1';
                else
                    rx_init <= '0';
                end if;
            end if;
        end if;
    end process monitor_init;
    
    -- Monitors the input_stream and sets rx_strt to '1'
    -- when the first transmission bit is available
    monitor_start: process (p_state, full_bit) is
    begin
        if (p_state = init_read) then
            if (full_bit = '1') then
                rx_strt <= '1';
            else
                rx_strt <= '0';
            end if;
        end if;
    end process monitor_start;
    
    -- Increments the current bit position while sampling the input_stream
    increment_pos: process(p_state, full_bit) is
    begin
        if (p_state = read_bits) then
            if (full_bit = '1') then
                bit_pos := bit_pos + 1;
                bit_pos_sig <= bit_pos;
            end if;
        end if;
    end process increment_pos;
    
    -- Monitors bit_pos_sig and sets rx_stop to '1' when
    -- all of the transmission bits have been received
    monitor_stop: process(p_state, bit_pos_sig) is
    begin
        if (p_state = read_bits) then
            if (bit_pos_sig > N_BITS - 1) then
                rx_stop <= '1';
            else
                rx_stop <= '0';
            end if;
        end if;
    end process monitor_stop;    
        
    -- If in the read_bits state, sample bits until the out_bits vector is filled
    -- If in the stop_read state, set rx_done to '1' when the transmission is finished
    sample_bits: process(p_state, sample_bit) is
    begin
        if (p_state = read_bits) then
            if (sample_bit = '1') then
                out_bits(bit_pos) <= input_stream;
            end if;
        elsif (p_state = stop_read) then
            if (sample_bit = '1') then
                if (input_stream = '1') then
                    rx_done <= '1';
                else
                    reset_UART <= '1';
                end if;
            end if;
        end if;
    end process sample_bits;
    
end Behavioral;