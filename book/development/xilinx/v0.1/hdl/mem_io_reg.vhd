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


entity mem_io_reg is Port (
	-- from config	
	mode        : in STD_LOGIC_VECTOR(3 downto 0);
	rsel        : in STD_LOGIC_VECTOR(2 downto 0);
	drive       : in STD_LOGIC;
	
	goe         : in STD_LOGIC; -- global enable IO
	-- from to matrix
    din         : out STD_LOGIC;
    dout        : in STD_LOGIC;

	--	to IO block instance
	P_I         : in STD_LOGIC;
	P_O         : out STD_LOGIC;
	P_T         : out STD_LOGIC
    );
end mem_io_reg;

architecture Behavioral of mem_io_reg is


begin
    din <= P_I;
    P_O <= dout;
    P_T <= not goe or not mode(2); -- TODO fake, it is forced push-pull on all output modes!

end Behavioral;
