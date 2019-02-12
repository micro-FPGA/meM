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

entity mem_lut3ff is Port (
    cclk        : in STD_LOGIC;
    cdi         : in STD_LOGIC;
    cdo         : out STD_LOGIC;
    lut_en      : in STD_LOGIC := '1';
    ff_en       : in STD_LOGIC := '1';
    por         : in STD_LOGIC := '0';
    
    a           : in STD_LOGIC_VECTOR(14 downto 0);
    q           : out STD_LOGIC_VECTOR(5 downto 0)
    );
end mem_lut3ff;

architecture Behavioral of mem_lut3ff is

signal sr: std_logic_vector(42 downto 0); -- 242:284

signal lut0_out: std_logic;
signal lut1_out: std_logic;

signal lutram_0: std_logic_vector(7 downto 0);
signal lutram_1: std_logic_vector(7 downto 0);
signal lutram_2: std_logic_vector(7 downto 0);
signal lutram_3: std_logic_vector(7 downto 0);
signal lutram_4: std_logic_vector(7 downto 0);

signal a0: std_logic_vector(2 downto 0);
signal a1: std_logic_vector(2 downto 0);
signal a2: std_logic_vector(2 downto 0);
signal a3: std_logic_vector(2 downto 0);
signal a4: std_logic_vector(2 downto 0);

signal dff2_out: std_logic;
signal dff3_out: std_logic;

signal dff2_clk: std_logic;
signal dff3_clk: std_logic;

signal dff2_d: std_logic;
signal dff3_d: std_logic;

signal dff2_q: std_logic;
signal dff3_q: std_logic;

begin
    a0 <= a(2 downto 0);
    a1 <= a(5 downto 3);
    a2 <= a(8 downto 6);
    a3 <= a(11 downto 9);
    a4 <= a(14 downto 12);    
    lutram_0 <= sr(7 downto 0);
    lutram_1 <= sr(15 downto 8);
    lutram_2 <= sr(23 downto 16);
    lutram_3 <= sr(31 downto 24);
    lutram_4 <= sr(39 downto 32);
      
    dff2_clk <= a0(0);
    dff2_d   <= a0(1) xor sr(3); -- 245 initial polarity invert input!

    dff3_clk <= a1(0);
    dff3_d   <= a1(1) xor sr(8+3); --       

    lut0_out <= lutram_0(to_integer(unsigned(a0))) and lut_en;
    lut1_out <= lutram_1(to_integer(unsigned(a1))) and lut_en;    
    q(0) <= lut0_out when sr(40) = '0' else dff2_out;
    q(1) <= lut1_out when sr(41) = '0' else dff3_out;
                
       
    q(2)  <= lutram_2(to_integer(unsigned(a2))) and lut_en;   
    q(3)  <= lutram_3(to_integer(unsigned(a3))) and lut_en;
    -- lut or pipe delay   
    q(4)  <= lutram_4(to_integer(unsigned(a4))) and lut_en;
    -- pipe delay 1
    q(5)  <= lut_en;   

    dff2_out <= dff2_q xor sr(  3) xor sr(  1);
    dff3_out <= dff3_q xor sr(8+3) xor sr(8+1);


   FDCE_DFF2 : FDCE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q     => dff2_q,      -- Data output
      C     => dff2_clk,    -- Clock input
      CE    => ff_en,       -- Clock enable input
      CLR   => por,         -- Asynchronous clear input
      D     => dff2_d       -- Data input
   );

   FDCE_DFF3 : FDCE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q     => dff3_q,      -- Data output
      C     => dff3_clk,    -- Clock input
      CE    => ff_en,       -- Clock enable input
      CLR   => por,         -- Asynchronous clear input
      D     => dff3_d       -- Data input
   );


      
  	process (cclk)
	begin
        if cclk'event and cclk = '1' then
           sr(42 downto 0) <= cdi & sr (42 downto 1); 
        end if;
	end process;
    cdo <= sr(0);

end Behavioral;
