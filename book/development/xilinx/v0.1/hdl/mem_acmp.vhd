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


entity mem_acmp is Port (
    port_in     : in STD_LOGIC_VECTOR(7 downto 0);
    pdb         : in STD_LOGIC_VECTOR(1 downto 0);
    q           : out STD_LOGIC_VECTOR(1 downto 0);
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC
    );
end mem_acmp;

architecture Behavioral of mem_acmp is

signal sr: std_logic_vector(22 downto 0); -- 

begin
    -- dummy founction, route input to output if power enabled	
    q(0) <= port_in(1) and pdb(0);  -- P3
    q(1) <= port_in(3) and pdb(1);  -- P6

	    
    cdo <= sr(0);
      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(22 downto 0) <= cdi & sr (22 downto 1); 
        end if;
	end process;


end Behavioral;
