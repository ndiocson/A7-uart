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
end component FIFO;

-- Input signals
signal clear        : std_logic;
signal write, read  : std_logic := '0';
signal in_data      : std_logic := '1';

-- Output signals
signal full, empty  : std_logic;
signal out_data     : std_logic;

begin

    -- Instatiates device under test
    DUT: FIFO
        Generic Map (DEPTH => open, DEFAULT_BIT => open)
        Port Map (clear => clear, write => write, read => read, in_data => in_data, full => full, empty => empty, out_data => out_data);
               
    -- Process to stimulate the in_data signal of DUT
    stimulus: process is
    begin
        wait for 10 ns;
        in_data <= '0';
        wait for 10 ns;
        in_data <= '1';
    end process stimulus;
    
    -- Process to control the write and read signals of DUT
    wr_control: process is
    begin
        
        for i in 0 to 7 loop
            wait for 5 ns;
            write <= '1';
            wait for 5 ns;
            write <= '0';
        end loop;
        
        wait for 10 ns;
        
        for i in 0 to 7 loop
            wait for 5 ns;
            read <= '1';
            wait for 5 ns;
            read <= '0';
        end loop;
        
        wait;
    end process wr_control;

end architecture Test;
