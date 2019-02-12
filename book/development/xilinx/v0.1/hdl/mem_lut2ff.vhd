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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity mem_lut2ff is Port (
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC;
    lut_en      : in STD_LOGIC := '1';
    ff_en       : in STD_LOGIC := '1';
    por         : in STD_LOGIC := '0';
     
    a           : in STD_LOGIC_VECTOR(7 downto 0);
    q           : out STD_LOGIC_VECTOR(3 downto 0)
    );
end mem_lut2ff;

architecture Behavioral of mem_lut2ff is

-- 224:241

signal sr: std_logic_vector(17 downto 0);

signal lutram_0: std_logic_vector(3 downto 0); 
signal lutram_1: std_logic_vector(3 downto 0);
signal lutram_2: std_logic_vector(3 downto 0);
signal lutram_3: std_logic_vector(3 downto 0);

signal a0: std_logic_vector(1 downto 0);
signal a1: std_logic_vector(1 downto 0);
signal a2: std_logic_vector(1 downto 0);
signal a3: std_logic_vector(1 downto 0);

signal lut0_out: std_logic;
signal lut1_out: std_logic;
signal lut2_out: std_logic;
signal lut3_out: std_logic;

signal dff0_out: std_logic;
signal dff1_out: std_logic;

signal dff0_clk: std_logic;
signal dff1_clk: std_logic;

signal dff0_d: std_logic;
signal dff1_d: std_logic;

signal dff0_q: std_logic;
signal dff1_q: std_logic;

begin
    a0 <= a(1 downto 0);
    a1 <= a(3 downto 2);
    a2 <= a(5 downto 4);
    a3 <= a(7 downto 6);
    
    dff0_clk <= a0(0);
    dff0_d   <= a0(1) xor sr(2); -- 226 initial polarity invert input!

    dff1_clk <= a1(0);
    dff1_d   <= a1(1) xor sr(4+2); -- 226
    
    lutram_0 <= sr( 3 downto  0); 
    lutram_1 <= sr( 7 downto  4);            
    lutram_2 <= sr(11 downto  8);            
    lutram_3 <= sr(15 downto 12);            
     
    lut0_out <= lutram_0(to_integer(unsigned(a0)));   
    lut1_out <= lutram_1(to_integer(unsigned(a1)));
    lut2_out <= lutram_2(to_integer(unsigned(a2)));
    lut3_out <= lutram_3(to_integer(unsigned(a3)));
       
    dff0_out <= dff0_q xor sr(  2) xor sr(  1);
    dff1_out <= dff1_q xor sr(4+2) xor sr(4+1);
        
    q(0) <= lut0_out when sr(16) = '0' else dff0_out;
    q(1) <= lut1_out when sr(17) = '0' else dff1_out;
    q(2) <= lut2_out;
    q(3) <= lut3_out;

    -- TODO implement DFF0/DFF



   FDCE_DFF0 : FDCE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q     => dff0_q,      -- Data output
      C     => dff0_clk,    -- Clock input
      CE    => ff_en,       -- Clock enable input
      CLR   => por,         -- Asynchronous clear input
      D     => dff0_d       -- Data input
   );

   FDCE_DFF1 : FDCE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q     => dff1_q,      -- Data output
      C     => dff1_clk,    -- Clock input
      CE    => ff_en,       -- Clock enable input
      CLR   => por,         -- Asynchronous clear input
      D     => dff1_d       -- Data input
   );



    --
    cdo <= sr(0);
      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(17 downto 0) <= cdi & sr (17 downto 1); 
        end if;
	end process;


end Behavioral;
