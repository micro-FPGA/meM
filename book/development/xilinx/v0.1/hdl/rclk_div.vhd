----------------------------------------------------------------------------------
-- Company: MicroFPGA UG
-- Engineer: Antti Lukats
-- 
-- Create Date: 12.01.2019
-- Design Name: 
-- Module Name: 
-- Project Name: meM "micro embeded Matrix"  
--               https://github.com/micro-FPGA/mEM
-- Target Devices: any
-- Tool Versions: any
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: 
--  mEM project was born when writing a book "Electronics? Simple! Again :)"
--  https://github.com/micro-FPGA/esa
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity rclk_div is Port (
    clk     : in STD_LOGIC;
    divout  : out STD_LOGIC
    );
end rclk_div;

architecture Behavioral of rclk_div is

signal cnt: unsigned(1 downto 0); -- 

begin
	divout <= cnt(1);

  	process (clk)
	begin
        if clk'event and clk = '1' then
		cnt <= cnt + 1;           
        end if;
	end process;


end Behavioral;
