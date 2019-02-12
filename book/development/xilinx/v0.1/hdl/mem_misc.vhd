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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity mem_misc is Port (
    pin2_in     : in STD_LOGIC := '0'; -- PIN2 input from I/O block
    pfd_in      : in STD_LOGIC; -- Programmable Delay/Filter input from matrix    
    q           : out STD_LOGIC_VECTOR(1 downto 0);
    
    ID          : out STD_LOGIC_VECTOR(7 downto 0);

    cdone       : in STD_LOGIC;
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC
    );
end mem_misc;

architecture Behavioral of mem_misc is

signal sr: std_logic_vector(79 downto 0); -- 432:511

begin
    ID <= sr(8 downto 1) when cdone = '1' else X"FF";
    
    -- fake just bypass
    -- TODO implement function ! 
    q(0) <= pin2_in;
    q(1) <= pfd_in;
    
    
    --
    cdo <= sr(0);
      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(79 downto 0) <= cdi & sr (79 downto 1); 
        end if;
	end process;


end Behavioral;
