----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Nick Diocson
-- 
-- Create Date: 10/28/2019 09:40:27 PM
-- Design Name: FIFO
-- Module Name: FIFO - Behavioral
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

entity FIFO is
    Generic (
            DEPTH       : integer := 8;
            DEFAULT_BIT : std_logic := '0'
            );
    Port ( 
            clear       : in std_logic;
            write, read : in std_logic;
            in_data     : in std_logic;
            full, empty : out std_logic;
            out_data    : out std_logic
            );
end entity FIFO;

architecture Behavioral of FIFO is

-- fifo_cap:    Defines the size of the buffer
-- fifo_arr:    Defines an array of size fifo_cap of std_logic bits
subtype fifo_cap is integer range 0 to DEPTH - 1;
type fifo_arr is array (fifo_cap) of std_logic;

-- fifo_full:       Internal signal used to indicate if buffer is full
-- fifo_empt:       Internal signal used to indicate if buffer is empty
-- curr_size:       Internal signal used to indicate current buffer size
-- fifo_buf:        Internal signal array used to store buffer bits
signal fifo_full    : std_logic := '0';
signal fifo_empt    : std_logic := '1';
signal curr_size    : fifo_cap := 0;
signal fifo_buf     : fifo_arr := (others => DEFAULT_BIT);

begin
    
    -- Internal signal fifo_full drives output port full
    full <= fifo_full;
    
    -- Internal signal fifo_empt drives output port empty
    empty <= fifo_empt;
    
    -- TODO: implement clear
    
    -- Tracks the current size of the buffer to control full and empty signals
    track_size: process(curr_size) is
    begin
        if (curr_size >= fifo_cap'high + 1) then
            fifo_full <= '1';
            fifo_empt <= '0';
        elsif (curr_size > fifo_cap'low and curr_size < fifo_cap'high + 1) then
            fifo_full <= '0';
            fifo_empt <= '0';
        else
            fifo_full <= '0';
            fifo_empt <= '1';
        end if;
    end process track_size;
    
    -- Writes data to the buffer if it is not full
    -- Reads data from the buffer if it is not empty
    control_fifo: process(write, read) is
    begin
        if (write = '1' and read = '0') then
            if (fifo_full /= '1') then
                fifo_buf(curr_size) <= in_data;
                curr_size <= curr_size + 1;
            end if;
        elsif (write = '0' and read = '1') then
            if (fifo_empt /= '1') then
                out_data <= fifo_buf(0);
                for index in 0 to DEPTH - 2 loop
                    fifo_buf(index) <= fifo_buf(index + 1);
                end loop;
                fifo_buf(DEPTH - 1) <= DEFAULT_BIT;
                curr_size <= curr_size - 1;
            end if;
        elsif (write = '1' and read = '1') then
            out_data <= in_data;
        end if;
    end process control_fifo;

end architecture Behavioral;
