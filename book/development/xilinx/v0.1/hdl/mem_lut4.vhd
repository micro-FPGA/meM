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


entity mem_lut4 is Port (
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC;
    lut_en      : in STD_LOGIC := '0';
    
    a           : in STD_LOGIC_VECTOR(3 downto 0);
    q           : out STD_LOGIC
    );
end mem_lut4;

architecture Behavioral of mem_lut4 is

signal sr: std_logic_vector(16 downto 0) := (others => '0');
signal lutram: std_logic_vector(15 downto 0);

signal lut_out: std_logic := '0';
signal cnt_out: std_logic := '0';

begin
    lutram <= sr(15 downto 0);                 
    lut_out <= lutram(to_integer(unsigned(a))) and lut_en;   
    q  <= lut_out when sr(16) = '0' else cnt_out;




    cdo <= sr(0);
      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(16 downto 0) <= cdi & sr (16 downto 1); 
        end if;
	end process;


end Behavioral;
