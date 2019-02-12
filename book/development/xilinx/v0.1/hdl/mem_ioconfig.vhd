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


entity mem_ioconfig is Port (
    mode        : out STD_LOGIC_VECTOR(8*4-1 downto 0);
    rsel        : out STD_LOGIC_VECTOR(8*3-1 downto 0);
    drive       : out STD_LOGIC_VECTOR(8-1 downto 0);
    --
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC
    );
end mem_ioconfig;

architecture Behavioral of mem_ioconfig is

signal sr: std_logic_vector(52 downto 0); -- 

begin
    cdo <= sr(0);
      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(52 downto 0) <= cdi & sr (52 downto 1); 
        end if;
	end process;

    -- PIN 2 379:382
    -- input only
    mode(3 downto 0) <= "00" & sr(1 downto 0);
    rsel(2 downto 0) <= "0"  & sr(3 downto 2);
    drive(0)         <= '0'; 
    
    -- PIN 3 383:389
    -- register control
    mode(4*1+3 downto 4*1)  <= "0" & sr(6 downto 4);
    rsel(3*1+2 downto 3*1)  <=       sr(9 downto 7);
    drive(1)                <=       sr(10); 
    
    -- PIN 4 390:396
    -- register control
    mode(4*2+3 downto 4*2)  <= "0" & sr(13 downto 11);
    rsel(3*2+2 downto 3*2)  <=       sr(16 downto 14);
    drive(2)                <=       sr(17); 
    
    -- PIN 6 397:403
    -- matrix OE control
    mode(4*3+3 downto 4*3)  <=       sr(21 downto 18);
    rsel(3*3+2 downto 3*3)  <=       sr(24 downto 22);
    drive(3)                <=       '0'; 
    
    -- PIN 8 
    -- register control
    mode(4*4+3 downto 4*4)  <= "0" & sr(27 downto 25);
    rsel(3*4+2 downto 3*4)  <=       sr(30 downto 28);
    drive(4)                <=       sr(31); 
    
    -- PIN 9 
    -- register control
    mode(4*5+3 downto 4*5)  <= "0" & sr(34 downto 32);
    rsel(3*5+2 downto 3*5)  <=       sr(37 downto 35);
    drive(5)                <=       sr(38); 
    
    -- PIN 10
    -- matrix OE control
    mode(4*6+3 downto 4*6)  <=       sr(42 downto 39);
    rsel(3*6+2 downto 3*6)  <=       sr(45 downto 43);
    drive(6)                <=       '0'; 
    
    -- PIN 12 
    -- register control
    mode(4*7+3 downto 4*7)  <= "0" & sr(48 downto 46);
    rsel(3*7+2 downto 3*7)  <=       sr(51 downto 49);
    drive(7)                <=       sr(52); 


end Behavioral;
