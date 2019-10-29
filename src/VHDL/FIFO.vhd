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
            SIZE    : integer := 8 
            );
    Port ( 
            reset   : in std_logic;
            in_bit  : in std_logic;
            out_bit : out std_logic
            );
end entity FIFO;

architecture Behavioral of FIFO is

-- fifo_cap:    Defines the size of the buffer
-- fifo_arr:    Defines an array of size fifo_cap of std_logic bits
subtype fifo_cap is integer range 0 to SIZE - 1;
type fifo_arr is array (fifo_cap) of std_logic;

-- fifo_buf:    Internal signal array used to store buffer bits
signal fifo_buf : fifo_arr := (others => '0');

begin
 
    -- Inserts a new bit into FIFO and shifts pre-exsiting bits
    buffer_bits: process(in_bit, reset) is
    begin
        if (reset /= '1') then
            fifo_buf(0) <= in_bit;
            for index in 1 to SIZE - 1 loop
                fifo_buf(index) <= fifo_buf(index - 1);
            end loop;
            out_bit <= fifo_buf(SIZE - 1);
        end if;
    end process buffer_bits;
    
end architecture Behavioral;
