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


entity mux32x44 is Port (
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC;
    a           : in STD_LOGIC_VECTOR (31 downto 0);
    q           : out STD_LOGIC_VECTOR (43 downto 0)
    );
end mux32x44;

architecture Behavioral of mux32x44 is

signal sr: std_logic_vector(223 downto 0); -- 4 bits are not used, reserved..

begin

    
GEN_MUX:
    for i in 0 to 43 generate
    begin
       q(i) <= a(to_integer(unsigned(sr(i*5+4 downto i*5))));
    end generate;
 
    cdo <= sr(0);
      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
          --if wren = '1' then
                --xout <= O;
           --end if;
           sr(223 downto 0) <= cdi & sr(223 downto 1); 
        end if;
	end process;



end Behavioral;
