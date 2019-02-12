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


entity mem_io_inp is Port (
	-- from config	
	mode        : in STD_LOGIC_VECTOR(3 downto 0);
	rsel        : in STD_LOGIC_VECTOR(2 downto 0);

	-- to matrix
    din         : out STD_LOGIC;

	--	to IO block instance
	P_I         : in STD_LOGIC;
	P_O         : out STD_LOGIC;
	P_T         : out STD_LOGIC
    );
end mem_io_inp;

architecture Behavioral of mem_io_inp is

begin
    din <= P_I;
    P_O <= '0';
    P_T <= '1'; -- input only

end Behavioral;
